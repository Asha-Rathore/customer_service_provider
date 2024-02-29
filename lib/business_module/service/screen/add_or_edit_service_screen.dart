import 'package:customer_service_provider_hybrid/business_module/service/bloc/add_service_bloc.dart';
import 'package:customer_service_provider_hybrid/business_module/service/bloc/delete_service_bloc.dart';
import 'package:customer_service_provider_hybrid/business_module/service/model/add_service_model.dart';
import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_confirmation_dialog.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_upload_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:customer_service_provider_hybrid/utils/field_validator.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/app_route_name.dart';
import '../../../utils/constants.dart';
import '../../../utils/image_gallery_class.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_textfield.dart';

class AddOrEditServiceScreen extends StatefulWidget {
  bool? isEditService, isFromProfile;
  int? serviceId;
  String? serviceName, serviceImage, location, description;

  AddOrEditServiceScreen(
      {Key? key,
      this.isEditService = false,
      this.isFromProfile = false,
      this.serviceId,
      this.serviceImage,
      this.description,
      this.location,
      this.serviceName})
      : super(key: key);

  @override
  State<AddOrEditServiceScreen> createState() => _AddOrEditServiceScreenState();
}

class _AddOrEditServiceScreenState extends State<AddOrEditServiceScreen> {
  final _serviceNameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _serviceFormKey = GlobalKey<FormState>();
  AddServiceBloc _addServiceBloc = AddServiceBloc();
  DeleteServicesBloc _deleteServicesBloc = DeleteServicesBloc();

  // Service? _service;
  // ServiceProvider? _serviceProvider;
  String? imagePath;
  bool? isFileImage = false;

  @override
  void initState() {
    // _serviceProvider = context.read<ServiceProvider>();
    _getServiceData();
    super.initState();
  }

  void _getServiceData() {
    print("SERVICE ID: ${widget.serviceId}");
    // print("SERVICE : ${_serviceProvider?.getService?.toJson()}");
    // if (_serviceProvider?.getService != null) {
    //   print("SERVICE INIT : ${_serviceProvider?.getService}");
    if (widget.isEditService == true) {
      // _service = _serviceProvider?.getService;
      imagePath = widget.serviceImage;
      _serviceNameCtrl.text = widget.serviceName ?? "";
      _locationCtrl.text = widget.location ?? "";
      _descriptionCtrl.text = widget.description ?? "";
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEditService!
        ? CustomAppTemplate(
            title: AppStrings.EDIT_YOUR_SERVICE,
            child: _formWidget(),
          )
        : widget.isFromProfile!
            ? CustomAppTemplate(
                title: AppStrings.ADD_A_SERVICE,
                child: _formWidget(),
              )
            : _formWidget();
  }

  Widget _formWidget() {
    return CustomPadding(
      child: Form(
        key: _serviceFormKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomSizeBox(height: 20.h),
                    _imageWidget(),
                    CustomSizeBox(height: 20.h),
                    _serviceNameTextField(),
                    CustomSizeBox(),
                    _locationTextField(),
                    CustomSizeBox(),
                    _descriptionTextField(),
                    CustomSizeBox(),
                    _button(),
                    if (widget.isEditService == true) ...[
                      CustomSizeBox(
                        height: 12.0,
                      ),
                      _deleteText(),
                      CustomSizeBox(
                        height: 25.h,
                      ),
                    ] else if (widget.isFromProfile == true) ...[
                      CustomSizeBox(
                        height: 15.0,
                      ),
                      _skipForNowText(),
                      CustomSizeBox(
                        height: 20.h,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: widget.isEditService == false && widget.isFromProfile == false? 30.0 : 0.0,)
            // CustomSizeBox(
            //   height: 35.0,
            // ),
            // _button(),
            //
            // if (widget.isEditService == true) ...[
            //   CustomSizeBox(
            //     height: 12.0,
            //   ),
            //   _deleteText(),
            //   CustomSizeBox(
            //     height: 25.h,
            //   ),
            // ] else if (widget.isFromProfile == true) ...[
            //   CustomSizeBox(
            //     height: 15.0,
            //   ),
            //   _skipForNowText(),
            //   CustomSizeBox(
            //     height: 25.h,
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return CustomUploadImage(
      imagePath: imagePath,
      isFileImage: isFileImage,
      isViewAsset: imagePath == null ? true : false,
      onTap: () {
        ImageGalleryClass().imageGalleryBottomSheet(
          context: context,
          onMediaChanged: (value) {
            setState(() {
              imagePath = value!;
              isFileImage = true;
              print("This is image ${imagePath}");
            });
          },
        );
      },
    );
  }

  Widget _serviceNameTextField() {
    return CustomTextField(
      controller: _serviceNameCtrl,
      hint: AppStrings.SERVICE_NAME,
      keyboardType: TextInputType.name,
      validator: (value) => value?.validateEmpty(AppStrings.SERVICE_NAME),
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
      ],
    );
  }

  Widget _locationTextField() {
    return CustomTextField(
      controller: _locationCtrl,
      hint: AppStrings.LOCATION,
      validator: (value) => value?.validateEmpty(AppStrings.LOCATION),
      readOnly: true,
      onTap: () async {
        final Prediction? prediction = await Constants.addressPicker(context);
        if (prediction != null) {
          Map<String, dynamic> address = await Constants.findStreetAreaMethod(
              context: context,
              prediction: prediction.description ?? _locationCtrl.text);
          setState(() {
            _locationCtrl.text = prediction.description ?? _locationCtrl.text;
          });
        }
      },
    );
  }

  Widget _descriptionTextField() {
    return CustomTextField(
      controller: _descriptionCtrl,
      hint: AppStrings.DESCRIPTION,
      lines: 8,
      validator: (value) => value?.validateEmpty(AppStrings.DESCRIPTION),
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.DESCRIPTION_MAX_LENGTH)
      ],
    );
  }

  Widget _button() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: widget.isEditService == false && widget.isFromProfile == false
              ? 35.0
              : 0.0),
      child: CustomButton(
        onTap: () => _serviceValidationMethod(context),
        text: widget.isEditService! ? AppStrings.SAVE : AppStrings.ADD,
      ),
    );
  }

  Widget _deleteText() {
    return GestureDetector(
      onTap: () {
        //_deleteServiceMethod(context);
        _deleteServiceDialog();
      },
      child: CustomText(
        text: AppStrings.DELETE,
        fontColor: AppColors.THEME_COLOR_PURPLE,
        fontSize: 16.sp,
        fontFamily: AppFonts.Jost_SemiBold,
      ),
    );
  }

  //Delete Service Dialog
  void _deleteServiceDialog() {
    showDialog(
        context: context,
        builder: (childContext) {
          return CustomConfirmationDialog(
            description: AppStrings.DO_YOU_WANT_TO_DELETE_SERVICE,
            button1Text: AppStrings.NO,
            button2Text: AppStrings.YES,
            onTapNo: () {},
            onTapYes: () {
              _deleteServiceMethod(context);
            },
          );
        });
  }

  Widget _skipForNowText() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(context, AppRouteName.MAIN_SCREEN_ROUTE,
            arguments: MainScreenRoutingArgument(index: 0));
      },
      child: CustomText(
        text: AppStrings.SKIP_FOR_NOW,
        fontColor: AppColors.THEME_COLOR_PURPLE,
        fontSize: 16.sp,
        fontFamily: AppFonts.Jost_SemiBold,
      ),
    );
  }

  void _serviceValidationMethod(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_serviceFormKey.currentState!.validate()) {
      _addServiceApiMethod(context);
    }
  }

  // ------------ Add Service Api Call Method ------------------- //
  void _addServiceApiMethod(BuildContext context) {
    print("service api");
    _addServiceBloc.addServiceBlocMethod(
      context: context,
      name: _serviceNameCtrl.text,
      location: _locationCtrl.text,
      description: _descriptionCtrl.text,
      serviceImage: isFileImage! ? imagePath : null,
      serviceId: widget.serviceId,
      isEdit: widget.isEditService!,
      setProgressBar: () {
        AppDialogs.progressAlertDialog(context: context);
      },
    );
  }

  void _deleteServiceMethod(BuildContext context) {
    _deleteServicesBloc.deleteService(
        context: context,
        serviceId: widget.serviceId,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        });
  }
}
