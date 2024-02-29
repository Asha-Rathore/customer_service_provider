import 'dart:async';
import 'dart:developer';

import 'package:customer_service_provider_hybrid/auth/enums/auth_roles.dart';
import 'package:customer_service_provider_hybrid/auth/model/user_model.dart';
import 'package:customer_service_provider_hybrid/auth/providers/auth_role_provider.dart';
import 'package:customer_service_provider_hybrid/chat/bloc/chat_attachment_bloc.dart';
import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/services/socket_service.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/utils/image_gallery_class.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:customer_service_provider_hybrid/utils/static_data.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../auth/providers/user_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_sizebox.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_textfield.dart';
import '../model/chat_model.dart';
import '../provider/chat_provider.dart';
import '../widgets/custom_chat_widget.dart';

class InboxScreen extends StatefulWidget {
  String? image, name;
  int? id;
  bool? notificationNavigationEnable;

  InboxScreen(
      {Key? key,
      this.image,
      this.name,
      this.id,
      this.notificationNavigationEnable})
      : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _imagePath;
  bool? _isFileUploaded = false;
  String? imagePath;
  bool isSender = true;
  User? _user;
  UserProvider? _userProvider;
  ChatProvider? _chatProvider;
  ChatAttachmentBloc? _chatAttachmentBloc = ChatAttachmentBloc();
  Timer? _timer;
  String? _role;

  // @override
  // void initState() {
  //   super.initState();
  //   // Scroll to the end of the list
  //   WidgetsBinding.instance!.addPostFrameCallback((_) {
  //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
    _initializeSocket();
    _chatProvider = context.read<ChatProvider>();
  }

  void _getUserDetails() {
    _userProvider = context.read<UserProvider>();
    if (_userProvider?.getCurrentUser != null) {
      _user = _userProvider?.getCurrentUser;
      _role = Provider.of<AuthRoleProvider>(context, listen: false).role;
    }
  }

  void _initializeProvider() {
    _chatProvider = context.watch<ChatProvider>();
  }

  @override
  Widget build(BuildContext context) {
    _initializeProvider();
    return WillPopScope(
      onWillPop: () async {
        _backMethod();
        return true;
      },
      child: CustomAppTemplate(
        title: widget.name ?? "",
        onClickLead: (){
          _backMethod();
        },
        // isDivider: true,
        child: Column(
          children: [
            CustomSizeBox(),
            const CustomPadding(child: CustomDivider()),
            CustomSizeBox(height: 15.h),
            // _day(AppStrings.YESTERDAY),
            Expanded(child: _buildList()),
            _customSenderMessageWidget(),
          ],
        ),
      ),
    );
  }



  Widget _buildList() {
    return _chatProvider!.isChatWaiting
        ? Center(child: AppDialogs.circularProgressWidget())
        : _chatProvider?.getReverseChatList != null &&
                (_chatProvider?.getReverseChatList?.length ?? 0) > 0
            ? _chatList()
            : Container();
  }

  Widget _chatList() {
    return ListView.builder(
      itemCount: _chatProvider?.getReverseChatList?.length ?? 0,
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      // shrinkWrap: true,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return CustomPadding(
          child: CustomChatWidget(
            userType:
                _user?.id != _chatProvider?.getReverseChatList?[index]?.senderId
                    ? AppStrings.receiver
                    : AppStrings.sender,
            messageText: _chatProvider?.getReverseChatList?[index]?.message,
            messageType: _chatProvider?.getReverseChatList?[index]?.type,
            senderProfileImage:
                _chatProvider?.getReverseChatList?[index]?.profileImage,
            receiverProfileImage: widget.image,
            // receiverProfileImage:
            //     _chatProvider?.getReverseChatList?[index]?.profileImage,
            // senderProfileImage: widget.image,
            name: _chatProvider?.getReverseChatList?[index]?.fullName,
            time: _chatProvider?.getReverseChatList?[index]?.createdAt,
          ),
        );
      },
    );
  }

  Widget _customSenderMessageWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          topLeft: Radius.circular(20.r),
        ),
        color: AppColors.THEME_COLOR_WHITE,
        boxShadow: [
          BoxShadow(
            color: AppColors.THEME_COLOR_LIGHT_GREY.withOpacity(0.6),
            offset: Offset(0, 1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CustomPadding(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  pickImage();
                },
                child: Image.asset(
                  AssetPath.ATTACH_FILE_ICON,
                  scale: 3,
                ),
              ),
              SizedBox(width: 10.w),
              _messageTextField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return Expanded(
      child: CustomTextField(
        hint: AppStrings.TYPE_YOUR_COMMENT_HERE,
        controller: _messageController,
        isSuffixIcon: true,
        suffixIcon: AssetPath.SEND_ICON,
        borderRadius: 10.r,
        onTapSuffix: () {
          sendMessageMethod(type: AppStrings.text);
        },
        scale: 2.5.sp,
      ),
    );
  }

  sendMessageMethod({String? type, String? image}) {
    if (type == AppStrings.text) {
      if (_messageController.text.trim().isNotEmpty) {
        FocusManager.instance.primaryFocus?.unfocus();
        _sendMessageEmitMethod(message: _messageController.text, type: type);
        _messageController.clear();
      }
    } else if (type == AppStrings.image) {
      print("SEND ATTACHMENT");
      print("SENDER ID ${_user?.id}");
      _chatAttachmentBloc?.chatAttachmentBlocMethod(
        senderId: _user?.id,
        receiverId: widget.id,
        attachment: image,
        context: context,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        },
      );
    }
  }

  Future pickImage() async {
    ImageGalleryClass().imageGalleryBottomSheet(
      context: context,
      onMediaChanged: (value) {
        setState(() {
          _imagePath = value;
          _isFileUploaded = true;
        });
        log("_imagePath  $_imagePath");
        sendMessageMethod(type: AppStrings.image, image: _imagePath);
        log("_imagePath 2421 $_imagePath");
      },
    );
  }

  void _initializeSocket() {
    // _chatProvider?.disposeChat();
    print("After Ok");
   context.read<ChatProvider>()?.disposeChat();
    SocketService.instance?.dispose();

    _timer = Timer(
      const Duration(seconds: 2),
      () {
        StaticData.chatRouting = AppRouteName.INBOX_SCREEN_ROUTE;
        StaticData.chatFriendId = widget.id;
      },
    );

    SocketService.instance?.initializeSocket();
    _connectSocket();
  }

  void _connectSocket() {
    SocketService.instance?.connectSocket();
    SocketService.instance?.socketResponseMethod();
    _getMessagesEmitMethod();
  }

  void _getMessagesEmitMethod() {
    SocketService.instance?.socketEmitMethod(
        eventName: NetworkStrings.GET_MESSAGES_EVENT,
        eventParamaters: {
          "sender_id": widget.id,
          "receiver_id": _user?.id,
        });
  }

  void _sendMessageEmitMethod({String? message, String? type}) {
    SocketService.instance?.socketEmitMethod(
        eventName: NetworkStrings.SEND_MESSAGE_EVENT,
        eventParamaters: {
          "sender_id": _user?.id,
          "receiver_id": widget.id,
          "type": type,
          "message": message,
        });
  }

  void _backMethod() {
    if (widget.notificationNavigationEnable == true) {
      if (_role == AuthRole.user.name) {
        AppNavigation.navigateToRemovingAll(
          context,
          AppRouteName.MAIN_SCREEN_ROUTE,
          arguments: MainScreenRoutingArgument(
            index: 1,
          ),
        );
      } else if (_role == AuthRole.business.name) {
        AppNavigation.navigateToRemovingAll(
          context,
          AppRouteName.MAIN_SCREEN_ROUTE,
          arguments: MainScreenRoutingArgument(
            index: 0,
          ),
        );
      }
    } else {
      AppNavigation.navigatorPop(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    StaticData.chatRouting = null;
    StaticData.chatFriendId = null;
    _timer?.cancel();
    super.dispose();
  }
}
