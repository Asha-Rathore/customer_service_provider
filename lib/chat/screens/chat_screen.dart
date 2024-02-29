import 'dart:async';

import 'package:customer_service_provider_hybrid/chat/model/chat_messages_model.dart';
import 'package:customer_service_provider_hybrid/chat/provider/chat_messages_provider.dart';
import 'package:customer_service_provider_hybrid/chat/routing_arguments/inbox_routing_argument.dart';
import 'package:customer_service_provider_hybrid/chat/widgets/chat_container.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../utils/app_strings.dart';
import '../../utils/asset_paths.dart';
import '../../widgets/custom_error_widget.dart';
import '../../widgets/custom_not_found_text_refresh_indicator_widget.dart';
import '../../widgets/custom_padding.dart';
import '../../widgets/custom_refresh_indicator_widget.dart';
import '../../widgets/custom_search_textfield.dart';
import '../../widgets/custom_sizebox.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _searchCtrl = TextEditingController();
  List<ChatMessagesModelData?>? searchList = [];
  ChatMessagesProvider? _chatMessagesProvider;
  Timer? _timer;
  bool _searchEnable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getChatList();
  }

  Future<void> _getChatList() async {
    _chatMessagesProvider = context.read<ChatMessagesProvider>();
    await _chatMessagesProvider?.getChatMessagesProviderMethod(
        context: context);
  }

  void _initializeProvider() {
    _chatMessagesProvider = context.watch<ChatMessagesProvider>();
  }

  @override
  Widget build(BuildContext context) {
    _initializeProvider();
    return Column(
      children: [
        _searchField(),
        CustomSizeBox(
          height: 7.h,
        ),
        _buildChatList(),
      ],
    );
  }

  Widget _buildChatList() {
    return Expanded(
      child: CustomRefreshIndicatorWidget(
        onRefresh: _getChatList,
        child: _chatMessagesProvider?.waitingStatus == true
            ? Center(child: AppDialogs.circularProgressWidget())
            : _buildList(),
      ),
    );
  }

  Widget _buildList() {
    _searchEnable = true;
    return _chatMessagesProvider?.waitingStatus == true
        ? AppDialogs.circularProgressWidget()
        : (_chatMessagesProvider?.getChatMessagesData?.data?.length ?? 0) > 0
            ? _customColumn()
            : Container(
                width: 1.sw,
                height: 1.sh,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  child: CustomDataNotFoundForRefreshIndicatorTextWidget(
                      notFoundText: AppStrings.CHAT_NOT_FOUND_ERROR, isSingleChildEnable: false),
                ),
              );
  }

  Widget _customColumn() {
    return _chatListView(
        chatList: _chatMessagesProvider?.getChatMessagesData?.data);
  }

  Widget _searchField() {
    return CustomPadding(
      child: CustomSearchBar(
        controller: _searchCtrl,
        hintText: AppStrings.SEARCH_HERE,
        onChange: (text) {
          if (_searchEnable == true) {
            _chatMessagesProvider?.searchChatMessagesMethod(searchText: text);
          } else {
            _searchCtrl.text = "";
            AppDialogs.showToast(message: AppStrings.SEARCH_INBOX_ERROR);
          }
        },
      ),
    );
  }

  Widget _chatListView({List<ChatMessagesModelData?>? chatList}) {
    return ListView.builder(
      itemCount: chatList?.length,
      itemBuilder: ((context, index) {
        return GestureDetector(
          onTap: () {
            Constants.unFocusKeyboardMethod(context: context);

            AppNavigation.navigateTo(
              context,
              AppRouteName.INBOX_SCREEN_ROUTE,
              arguments: InboxRoutingArgument(
                name: chatList?[index]?.fullName,
                image: chatList?[index]?.profileImage,
                id: chatList?[index]?.id,
              ),
            );

              _searchCtrl.text = "";

            _chatMessagesProvider?.searchChatMessagesMethod(searchText: "");

          },
          child: ChatContainer(
            image: chatList?[index]?.profileImage,
            companyName: chatList?[index]?.fullName,
            detail: chatList?[index]?.type == AppStrings.image
                ? "Photo"
                : chatList?[index]?.lastMessage,
            time: chatList?[index]?.days,
          ),
        );
      }),
    );
  }


}
