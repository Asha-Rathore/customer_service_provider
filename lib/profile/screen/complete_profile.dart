import 'dart:convert';
import 'dart:developer';

import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/profile/bloc/complete_profile_bloc.dart';
import 'package:customer_service_provider_hybrid/profile/model/langauges_model.dart';
import 'package:customer_service_provider_hybrid/profile/widget/language_widget.dart';
import 'package:customer_service_provider_hybrid/utils/app_fonts.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_phonenumber_txtfield.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

import '../../auth/enums/auth_roles.dart';
import '../../auth/enums/social_type.dart';
import '../../auth/model/user_model.dart';
import '../../auth/providers/auth_role_provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_navigation.dart';
import '../../utils/asset_paths.dart';
import '../../utils/image_gallery_class.dart';
import '../../utils/regular_expressions.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_padding.dart';
import '../../widgets/custom_searchable_dropdown.dart';
import '../../widgets/custom_sizebox.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_upload_image.dart';
import 'package:customer_service_provider_hybrid/utils/field_validator.dart';
import 'package:collection/collection.dart';

class CompleteProfile extends StatefulWidget {
  String? fullName;
  String? emailAddress;
  String? token;

  CompleteProfile({Key? key, this.fullName, this.emailAddress, this.token})
      : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final _nameCtrl = TextEditingController();
  final _companyNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _companyDescriptionCtrl = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final _profileFormKey = GlobalKey<FormState>();
  final _completeProfileBloc = CompleteprofileBloc();

  List<String> preferredLanguage = [], _tempPreferredLanguage = [];
  AuthRoleProvider? _authRoleProvider;
  User? _user;
  UserProvider? _userProvider;

  bool? buttonPressed = false;
  String? imagePath = null;
  // bool isViewAsset = true;
  bool? isFileImage = false;
  //int? phoneLength = 1;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _authRoleProvider = context.read<AuthRoleProvider>();
    readJson();
    setData();
    _getUserData();
  }

  setData() {
    setState(() {
      _emailCtrl.text = widget.emailAddress ?? "";
      _nameCtrl.text = widget.fullName ?? "";
    });
  }

  void _getUserData() {
    if (_userProvider?.getCurrentUser != null) {
      log("in init");
      _user = _userProvider?.getCurrentUser;
    }
  }

  List<LanguagesModel> phoneTextField = [
    // LanguagesModel(
    //   textField: TextEditingController(),
    // )
  ];

  //shumaila's code
  List<String> _items = [];
  List<String> languageNames = [];
  List<String> countryCodes = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
    await rootBundle.loadString(AppStrings.langaugeListPath);
    final data = await json.decode(response);

    final languagesData =
    data["languages"]; // Extracting the value corresponding to "languages"

    if (languagesData is List) {
      setState(() {
        _items = languagesData.map((dynamic item) => item.toString()).toList();
      });
    } else {
      // Handle the case if "languages" data is not in the expected format
    }
    for (var item in data["languages"]) {
      setState(() {
        languageNames.add(item["Language_name"]);
        countryCodes.add(item["Country_code"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _authRoleProvider = context.watch<AuthRoleProvider>();
    return Container(
      width: 1.sw,
      height: 1.sh,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetPath.APP_BACKGROUND_IMAGE),
          fit: BoxFit.cover,
        ),
      ),
      child: _scaffoldWidget(context),
    );
  }

  Widget _scaffoldWidget(context) {
    return Scaffold(
      backgroundColor: AppColors.THEME_COLOR_TRANSPARENT,
      appBar: _appBar(context),
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _formWidget(),
            _imageWidget(),
          ],
        ),
      ),
    );
  }

  CustomAppBar _appBar(context) {
    return CustomAppBar(
      title: AppStrings.PROFILE,
      color: AppColors.THEME_COLOR_WHITE,
    );
  }

  Widget _formWidget() {
    return CustomPadding(
      child: Padding(
        padding: EdgeInsets.only(top: 100.h, bottom: 10.h),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_WHITE,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 70.h),
            child: SingleChildScrollView(
              child: CustomPadding(
                child: Form(
                  key: _profileFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      _nameTextField(),
                      if (_authRoleProvider?.role ==
                          AuthRole.business.name) ...[
                        CustomSizeBox(),
                        _companyNameTextField(),
                      ],

                      _emailTextField(),
                      // if (_authRoleProvider?.role == AuthRole.business.name) ...[
                      //   CustomSizeBox(),
                      //   _emailTextField(),
                      // ] else if (_authRoleProvider?.role ==
                      //     AuthRole.user.name) ...[
                      //   if (_user?.userSocialType ==
                      //       SocialAuthType.google.name) ...[
                      //     SizedBox(),
                      //   ] else ...[
                      //     CustomSizeBox(),
                      //     _emailTextField(),
                      //   ]
                      // ],
                      CustomSizeBox(),
                      phoneTxtField(),
                      // CustomSizeBox(),
                      // _phoneNumberTextField(),
                      if (_authRoleProvider?.role ==
                          AuthRole.business.name) ...[
                        CustomSizeBox(
                          // height: 4.h,
                        ),
                        _addressTextField(),
                        CustomSizeBox(
                          // height: 4.h,
                        ),
                        _websiteTextField(),
                        CustomSizeBox(
                          // height: 7.h,
                        ),
                        _companyDescriptionTextField(),
                        CustomSizeBox(),
                        _businessPreferredLanguageDropDown(),
                        ...List.generate(
                          (preferredLanguage.length),
                              (index) => LanguageWidget(
                            text: preferredLanguage[index],
                            onTapDelete: () {
                              // print("data");
                              setState(() {
                                preferredLanguage.removeAt(index);
                                phoneTextField.removeAt(index);
                                // phoneLength =
                                //     phoneTextField[index].textField?.length;
                              });

                              print("Preferred Language:${preferredLanguage}");

                            },
                            onTapAdd: () {
                              setState(() {
                                phoneTextField[index].textField?.add(
                                  TextEditingController(),
                                );
                                // phoneLength =
                                //     phoneTextField[index].textField?.length;
                              });
                            },
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                              phoneTextField[index].textField?.length,
                              itemBuilder: ((context, i) {
                                // log("phoneTextField[index].code  ${phoneTextField[index].code}  ${countryCodes[index]}");
                                return Row(
                                  children: [
                                    // Text("${countryCodes[languageNames.indexOf(preferredLanguage![index])]??""}"),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 10.h),
                                        child: _languagesPhoneNumberTextField(
                                          length: i,
                                          code: countryCodes[
                                          languageNames.indexOf(
                                              preferredLanguage[index])],
                                          controller: phoneTextField[index]
                                              .textField?[i],
                                          onTapSuffix: () {
                                            if (preferredLanguage.length != 0) {
                                              setState(() {
                                                buttonPressed = false;
                                                // phoneLength =
                                                //     phoneTextField[index]
                                                //         .textField
                                                //         ?.length;
                                              });
                                            }
                                            setState(() {
                                              phoneTextField[index]
                                                  .textField
                                                  ?.removeAt(i);
                                              // phoneLength =
                                              //     phoneTextField[index]
                                              //         .textField
                                              //         ?.length;
                                              // print(
                                              //     "LENGTH: ${phoneTextField[index].textField?.length}, ${phoneLength}");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ] else ...[
                        CustomSizeBox(
                          height: 4.h,
                        ),
                        _addressTextField(),
                        CustomSizeBox(
                          height: 7.h,
                        ),
                        _userPreferredLanguageDropDown(),
                      ],
                      preferredLanguageError(
                          isVisible: buttonPressed == true
                              ? preferredLanguage?.length == 0
                              ? true
                              : false
                              : false),
                      CustomSizeBox(),
                      _button(),
                      CustomSizeBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: CustomUploadImage(
          borderColor: AppColors.THEME_COLOR_WHITE,
          imagePath: imagePath,
          isFileImage: isFileImage,
          // isViewAsset: isViewAsset,
          onTap: () {
            ImageGalleryClass().imageGalleryBottomSheet(
              context: context,
              onMediaChanged: (value) {
                setState(() {
                  imagePath = value!;
                  isFileImage = true;
                  // isViewAsset = false;
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return CustomTextField(
      controller: _nameCtrl,
      hint: AppStrings.FULL_NAME,
      keyboardType: TextInputType.name,
      validator: (value) => value?.validateEmpty(AppStrings.FULL_NAME),
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
      ],
    );
  }

  Widget _companyNameTextField() {
    return CustomTextField(
      controller: _companyNameCtrl,
      hint: AppStrings.COMPANY_NAME,
      keyboardType: TextInputType.name,
      validator: (value) => value?.validateEmpty(AppStrings.COMPANY_NAME),
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
      ],
    );
  }

  Widget _emailTextField() {

    print("User Email:${_user?.email}");

    return Visibility(
      visible: _authRoleProvider?.role == AuthRole.user.name && (_user?.userSocialType == SocialAuthType.google.name || _user?.userSocialType == SocialAuthType.apple.name) ? false : true,
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: CustomTextField(
          controller: _emailCtrl,
          hint: AppStrings.EMAIL_ADDRESS,
          keyboardType: TextInputType.emailAddress,
          readOnly: (widget.emailAddress ?? "").isNotEmpty ? true : false,
          validator: (value) => value?.validateEmail,
          inputFormatters: [
            LengthLimitingTextInputFormatter(Constants.EMAIL_MAX_LENGTH)
          ],
        ),
      ),
    );
  }

  Widget _languagesPhoneNumberTextField(
      {length, controller, onTapSuffix, code}) {
    return CustomTextField(
      suffixIcon: AssetPath.CROSS_ICON,
      isSuffixIcon: length == 0 ? false : true,
      onTapSuffix: onTapSuffix,
      suffixScale: 5,
      controller: controller,
      hint: AppStrings.PHONE_NUMBER,
      validator: (value) => value?.validatePhoneNumber,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.PHONE_NUMBER_LENGTH),
        FilteringTextInputFormatter.digitsOnly
      ],
      // inputFormatters: [RegularExpressions.MASK_TEXT_FORMATTER_PHONE_NO],
    );
    // return PhoneNumberTextField(
    //   isSuffixIcon: length == 0 ? false : true,
    //   onTapSuffixIcon: onTapSuffix,
    //   suffixIcon: Icons.cancel,
    //   showDialogue: false,
    //   isEnabled: true,
    //   countryCode: code ?? "US",
    //   isReadOnly: false,
    //   controller: controller,
    //   showFlag: true,
    //   isBorder: true,
    //   validator: (value) async {
    //     return value?.completeNumber;
    //   },
    // );
  }

  Widget phoneTxtField() {
    return CustomTextField(
      controller: phoneNumberController,
      hint: AppStrings.PHONE_NUMBER,
      validator: (value) => value?.validatePhoneNumber,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.PHONE_NUMBER_LENGTH)
      ],
      // inputFormatters: [RegularExpressions.MASK_TEXT_FORMATTER_PHONE_NO],
    );
  }

  Widget _websiteTextField() {
    return CustomTextField(
      controller: _websiteCtrl,
      hint: AppStrings.WEBSITE,
      validator: (value) => value?.validateWebsite(_websiteCtrl.text),
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
      ],
    );
  }

  Widget _addressTextField() {
    return CustomTextField(
      controller: _addressCtrl,
      hint: AppStrings.ADDRESS,
      validator: (value) => value?.validateEmpty(AppStrings.ADDRESS),
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
      ],
      // validator: (value) => value?.validateEmpty("Feedback"),
      readOnly: true,
      onTap: () async {
        final Prediction? prediction = await Constants.addressPicker(context);
        if (prediction != null) {
          _addressCtrl.text = prediction.description ?? _addressCtrl.text;
        }
      },
    );
  }

  Widget _userPreferredLanguageDropDown() {
    return CustomSearchableDropDown(
      dropDownData: languageNames,
      hintText: AppStrings.PREFERRED_LANGUAGE,
      prefix: SizedBox(width: 10.w),
      horizontalPadding: 0,
      selectedItems: preferredLanguage,
      isMultiSelection: true,
      showTags: true,
      // multiValueValidator: (validateValue){
      //   if((validateValue?.length ?? 0) > 0){
      //    return null;
      //   }
      //
      //   return "Error";
      // },
      onChanged: (value) {
        setState(() {
          preferredLanguage = value ?? [];
          buttonPressed = false;
        });
      },
    );
  }

  Widget _businessPreferredLanguageDropDown() {
    return CustomSearchableDropDown(
      dropDownData: languageNames,
      hintText: AppStrings.PREFERRED_LANGUAGE,
      prefix: SizedBox(width: 10.w),
      horizontalPadding: 0,
      selectedItems: preferredLanguage,
      isMultiSelection: true,
      showTags: false,
      onChanged: (value) {

        if ((value?.length ?? 0) > preferredLanguage.length) {
          // tempLength = (value?.length ?? 0) - preferredLanguage.length;
          // print("Temp Length:${tempLength}");
          print("Preferred Length:${preferredLanguage.length}");

          for (int k = preferredLanguage.length; k < value!.length; k++) {
            preferredLanguage.add(value[k]);
            buttonPressed = false;
            phoneTextField.add(LanguagesModel(
              index: k,
              countryCode: "US",
              phoneCode: "+1",
              textField: [TextEditingController()],
              language: value[k],
            ));

          }
        } else if ((value?.length ?? 0) < preferredLanguage.length) {
          //this is used to remove phone data
          _tempPreferredLanguage = List.from(preferredLanguage);
          // print("Temp Preferred Langugae:${_tempPreferredLanguage}");

          for (int z = 0; z < _tempPreferredLanguage.length; z++) {
            if (!((value?.contains(_tempPreferredLanguage[z])) ?? true)) {
              preferredLanguage.remove(_tempPreferredLanguage[z]);
              phoneTextField.firstWhereOrNull((phoneData) =>
              phoneData.language == _tempPreferredLanguage[z]
              );

              //print("Phone text field:${phoneTextField.length}");
            }
          }
        }

        setState(() {});
      },
    );
  }

  Widget _companyDescriptionTextField() {
    return CustomTextField(
      controller: _companyDescriptionCtrl,
      hint: AppStrings.DESCRIPTION,
      lines: 5,
      keyboardType: TextInputType.name,
      validator: (value) => value?.validateEmpty(AppStrings.DESCRIPTION),
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.DESCRIPTION_MAX_LENGTH)
      ],
    );
  }

  Widget _button() {
    return CustomButton(
      onTap: () {
        setState(() {
          buttonPressed = true;
        });
        if (_profileFormKey.currentState!.validate() &&
            (preferredLanguage?.length ?? 0) > 0) {
          _completeProfileApiMethod(context);
          // if (_authRoleProvider?.role == AuthRole.business.name) {
          //   AppNavigation.navigateTo(
          //       context, AppRouteName.SUBSCRIPTION_PLAN_SCREEN_ROUTE,
          //       arguments: true);
          // } else {
          //   AppNavigation.navigateTo(context, AppRouteName.MAIN_SCREEN_ROUTE,
          //       arguments: MainScreenRoutingArgument(index: 1));
          // }
        }
      },
      text: AppStrings.CONTINUE,
    );
  }

  Widget preferredLanguageError({bool? isVisible}) {
    return Visibility(
        visible: isVisible ?? false,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: CustomText(
              text: "Preferred language can't be empty",
              fontColor: AppColors.THEME_COLOR_RED,
              fontSize: 12,
              fontFamily: AppFonts.Jost_Regular,
            ),
          ),
        ));
  }

  // ------------ Complete Profile Api Call Method ------------------- //
  void _completeProfileApiMethod(BuildContext context) {

    Constants.unFocusKeyboardMethod(context: context);

    // for(int i=0;i<phoneTextField.length;i++){
    //   print("Phone Data:${phoneTextField[i].code}");
    //   print("Phone Data:${phoneTextField[i].language}");
    //   for(int j=0;j<(phoneTextField[i].textField?.length ?? 0);j++){
    //     print("Phone Data:${phoneTextField[i].textField?[j]?.text}");
    //   }
    // }

    _completeProfileBloc.completeProfileBlocMethod(
        context: context,
        fullName: _nameCtrl.text,
        companyName: _companyNameCtrl.text,
        phoneNumber: phoneNumberController.text,
        phoneCode: "+1",
        countryCode: "US",
        profileImage: imagePath,
        address: _addressCtrl.text,
        website: _websiteCtrl.text,
        preferredLanguage: preferredLanguage,
        preferredCountryCode: null,
        companyDescription: _companyDescriptionCtrl.text,
        role: _authRoleProvider?.role,
        phoneNumberLength: 0,
        isEditProfile: false,
        languagePhoneNumbersList: phoneTextField,
        email: _emailCtrl.text,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        });

    // print("complete profile: ${countryCodes}");

    print("ROLE : ${_authRoleProvider?.role}");
  }
}


// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
// import 'package:customer_service_provider_hybrid/profile/bloc/complete_profile_bloc.dart';
// import 'package:customer_service_provider_hybrid/profile/model/langauges_model.dart';
// import 'package:customer_service_provider_hybrid/profile/widget/language_widget.dart';
// import 'package:customer_service_provider_hybrid/utils/app_fonts.dart';
// import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
// import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
// import 'package:customer_service_provider_hybrid/utils/constants.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_phonenumber_txtfield.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:provider/provider.dart';
//
// import '../../auth/enums/auth_roles.dart';
// import '../../auth/providers/auth_role_provider.dart';
// import '../../utils/app_colors.dart';
// import '../../utils/app_dialogs.dart';
// import '../../utils/app_navigation.dart';
// import '../../utils/asset_paths.dart';
// import '../../utils/image_gallery_class.dart';
// import '../../utils/regular_expressions.dart';
// import '../../widgets/custom_app_bar.dart';
// import '../../widgets/custom_padding.dart';
// import '../../widgets/custom_searchable_dropdown.dart';
// import '../../widgets/custom_sizebox.dart';
// import '../../widgets/custom_textfield.dart';
// import '../../widgets/custom_upload_image.dart';
// import 'package:customer_service_provider_hybrid/utils/field_validator.dart';
//
// class CompleteProfile extends StatefulWidget {
//   String? fullName;
//   String? emailAddress;
//   String? token;
//   CompleteProfile({Key? key, this.fullName, this.emailAddress, this.token})
//       : super(key: key);
//
//   @override
//   State<CompleteProfile> createState() => _CompleteProfileState();
// }
//
// class _CompleteProfileState extends State<CompleteProfile> {
//   final _nameCtrl = TextEditingController();
//   final _companyNameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _websiteCtrl = TextEditingController();
//   final _addressCtrl = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//
//   final _profileFormKey = GlobalKey<FormState>();
//   final _completeProfileBloc = CompleteprofileBloc();
//
//   List<String>? preferredLanguage = [];
//   List<String>? countryCode = [];
//   AuthRoleProvider? _authRoleProvider;
//
//   bool? buttonPressed = false;
//   String? imagePath = null;
//
//   int? phoneLength = 1;
//
//   @override
//   void initState() {
//     super.initState();
//     _authRoleProvider = context.read<AuthRoleProvider>();
//     readJson();
//     setData();
//   }
//
//   setData() {
//     setState(() {
//       _emailCtrl.text = widget.emailAddress ?? "";
//       _nameCtrl.text = widget.fullName ?? "";
//     });
//   }
//
//   List<LanguagesModel> phoneTextField = [
//     // LanguagesModel(
//     //   textField: TextEditingController(),
//     // )
//   ];
//
//   //shumaila's code
//   List<String> _items = [];
//   List<String> languageNames = [];
//   List<String> countryCodes = [];
//
//   // Fetch content from the json file
//   Future<void> readJson() async {
//     final String response =
//         await rootBundle.loadString(AppStrings.langaugeListPath);
//     final data = await json.decode(response);
//
//     final languagesData =
//         data["languages"]; // Extracting the value corresponding to "languages"
//
//     if (languagesData is List) {
//       setState(() {
//         _items = languagesData.map((dynamic item) => item.toString()).toList();
//       });
//     } else {
//       // Handle the case if "languages" data is not in the expected format
//     }
//     for (var item in data["languages"]) {
//       setState(() {
//         languageNames.add(item["Language_name"]);
//         countryCodes.add(item["Country_code"]);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _authRoleProvider = context.watch<AuthRoleProvider>();
//     return Container(
//       width: 1.sw,
//       height: 1.sh,
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(AssetPath.APP_BACKGROUND_IMAGE),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: _scaffoldWidget(context),
//     );
//   }
//
//   Widget _scaffoldWidget(context) {
//     return Scaffold(
//       backgroundColor: AppColors.THEME_COLOR_TRANSPARENT,
//       appBar: _appBar(context),
//       body: Center(
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             _formWidget(),
//             _imageWidget(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   CustomAppBar _appBar(context) {
//     return CustomAppBar(
//       title: AppStrings.PROFILE,
//       color: AppColors.THEME_COLOR_WHITE,
//     );
//   }
//
//   Widget _formWidget() {
//     return CustomPadding(
//       child: Padding(
//         padding: EdgeInsets.only(top: 100.h, bottom: 10.h),
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: AppColors.THEME_COLOR_WHITE,
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           child: Padding(
//             padding: EdgeInsets.only(top: 70.h),
//             child: SingleChildScrollView(
//               child: CustomPadding(
//                 child: Form(
//                   key: _profileFormKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(
//                         height: 20.h,
//                       ),
//                       _nameTextField(),
//                       if (_authRoleProvider?.role ==
//                           AuthRole.business.name) ...[
//                         CustomSizeBox(),
//                         _companyNameTextField(),
//                       ],
//                       CustomSizeBox(),
//                       _emailTextField(),
//                       CustomSizeBox(),
//                       phoneTxtField(),
//                       // CustomSizeBox(),
//                       // _phoneNumberTextField(),
//                       if (_authRoleProvider?.role ==
//                           AuthRole.business.name) ...[
//                         CustomSizeBox(
//                             // height: 4.h,
//                             ),
//                         _websiteTextField(),
//                         CustomSizeBox(
//                             // height: 7.h,
//                             ),
//                         _businessPreferredLanguageDropDown(),
//                         ...List.generate(
//                           (preferredLanguage!.length),
//                           (index) => LanguageWidget(
//                             text: preferredLanguage![index],
//                             onTapDelete: () {
//                               setState(() {
//                                 preferredLanguage!.removeAt(index);
//                                 phoneLength =
//                                     phoneTextField[index].textField?.length;
//                                 print(
//                                     "LENGTH: ${phoneTextField[index].textField?.length}, ${phoneLength}");
//                               });
//                             },
//                             onTapAdd: () {
//                               setState(() {
//                                 phoneTextField[index].textField?.add(
//                                       TextEditingController(),
//                                     );
//                                 phoneLength =
//                                     phoneTextField[index].textField?.length;
//                                 print(
//                                     "LENGTH: ${phoneTextField[index].textField?.length}, ${phoneLength}");
//                               });
//                             },
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount:
//                                   phoneTextField[index].textField?.length,
//                               itemBuilder: ((context, i) {
//                                 // log("phoneTextField[index].code  ${phoneTextField[index].code}  ${countryCodes[index]}");
//                                 return Row(
//                                   children: [
//                                     // Text("${countryCodes[languageNames.indexOf(preferredLanguage![index])]??""}"),
//                                     Expanded(
//                                       child: Padding(
//                                         padding: EdgeInsets.only(bottom: 10.h),
//                                         child: _languagesPhoneNumberTextField(
//                                           length: i,
//                                           code: countryCodes[
//                                               languageNames.indexOf(
//                                                   preferredLanguage![index])],
//                                           controller: phoneTextField[index]
//                                               .textField?[i],
//                                           onTapSuffix: () {
//                                             if (preferredLanguage!.length !=
//                                                 0) {
//                                               setState(() {
//                                                 buttonPressed = false;
//                                                 phoneLength =
//                                                     phoneTextField[index]
//                                                         .textField
//                                                         ?.length;
//                                                 print(
//                                                     "LENGTH: ${phoneTextField[index].textField?.length}, ${phoneLength}");
//                                               });
//                                             }
//                                             setState(() {
//                                               phoneTextField[index]
//                                                   .textField
//                                                   ?.removeAt(i);
//                                               phoneLength =
//                                                   phoneTextField[index]
//                                                       .textField
//                                                       ?.length;
//                                               print(
//                                                   "LENGTH: ${phoneTextField[index].textField?.length}, ${phoneLength}");
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }),
//                             ),
//                           ),
//                         ),
//                       ] else ...[
//                         CustomSizeBox(
//                           height: 4.h,
//                         ),
//                         _addressTextField(),
//                         CustomSizeBox(
//                           height: 7.h,
//                         ),
//                         _userPreferredLanguageDropDown(),
//                       ],
//                       preferredLanguageError(
//                           isVisible: buttonPressed == true
//                               ? preferredLanguage?.length == 0
//                                   ? true
//                                   : false
//                               : false),
//                       CustomSizeBox(),
//                       _button(),
//                       CustomSizeBox(height: 20.h),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _imageWidget() {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: Padding(
//         padding: EdgeInsets.only(top: 40.0),
//         child: CustomUploadImage(
//           borderColor: AppColors.THEME_COLOR_WHITE,
//           imagePath: imagePath,
//           onTap: () {
//             ImageGalleryClass().imageGalleryBottomSheet(
//               context: context,
//               onMediaChanged: (value) {
//                 setState(() {
//                   imagePath = value!;
//                 });
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _nameTextField() {
//     return CustomTextField(
//       controller: _nameCtrl,
//       hint: AppStrings.FULL_NAME,
//       keyboardType: TextInputType.name,
//       validator: (value) => value?.validateEmpty(AppStrings.FULL_NAME),
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
//       ],
//     );
//   }
//
//   Widget _companyNameTextField() {
//     return CustomTextField(
//       controller: _companyNameCtrl,
//       hint: AppStrings.COMPANY_NAME,
//       keyboardType: TextInputType.name,
//       validator: (value) => value?.validateEmpty(AppStrings.COMPANY_NAME),
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
//       ],
//     );
//   }
//
//   Widget _emailTextField() {
//     return CustomTextField(
//       controller: _emailCtrl,
//       hint: AppStrings.EMAIL_ADDRESS,
//       keyboardType: TextInputType.emailAddress,
//       readOnly: _authRoleProvider?.role == AuthRole.business.name ? false : true,
//       validator: (value) => value?.validateEmail,
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(Constants.EMAIL_MAX_LENGTH)
//       ],
//     );
//   }
//
//   Widget _languagesPhoneNumberTextField(
//       {length, controller, onTapSuffix, code}) {
//     return CustomTextField(
//       suffixIcon: AssetPath.CROSS_ICON,
//       isSuffixIcon: length == 0 ? false : true,
//       onTapSuffix: onTapSuffix,
//       suffixScale: 5,
//       controller: controller,
//       hint: AppStrings.PHONE_NUMBER,
//       validator: (value) => value?.validatePhoneNumber,
//       keyboardType: TextInputType.phone,
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(Constants.PHONE_NUMBER_LENGTH)
//       ],
//       // inputFormatters: [RegularExpressions.MASK_TEXT_FORMATTER_PHONE_NO],
//     );
//     // return PhoneNumberTextField(
//     //   isSuffixIcon: length == 0 ? false : true,
//     //   onTapSuffixIcon: onTapSuffix,
//     //   suffixIcon: Icons.cancel,
//     //   showDialogue: false,
//     //   isEnabled: true,
//     //   countryCode: code ?? "US",
//     //   isReadOnly: false,
//     //   controller: controller,
//     //   showFlag: true,
//     //   isBorder: true,
//     //   validator: (value) async {
//     //     return value?.completeNumber;
//     //   },
//     // );
//   }
//
//   Widget phoneTxtField() {
//     return CustomTextField(
//       controller: phoneNumberController,
//       hint: AppStrings.PHONE_NUMBER,
//       validator: (value) => value?.validatePhoneNumber,
//       keyboardType: TextInputType.phone,
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(Constants.PHONE_NUMBER_LENGTH)
//       ],
//       // inputFormatters: [RegularExpressions.MASK_TEXT_FORMATTER_PHONE_NO],
//     );
//   }
//
//   // phoneTxtField() {
//   //   return PhoneNumberTextField(
//   //     isEnabled: true,
//   //     countryCode: AppStrings.defaultCountryCode,
//   //     showDialogue: true,
//   //     isReadOnly: false,
//   //     controller: phoneNumberController,
//   //     showDropDown: true,
//   //     showFlag: true,
//   //     isBorder: true,
//   //     onchange: (value) async {
//   //       return null;
//   //     },
//   //     backgroundColor: AppColors.THEME_COLOR_OFF_WHITE,
//   //     validator: (value) async {
//   //       return value?.completeNumber;
//   //     },
//   //   );
//   // }
//
//   Widget _websiteTextField() {
//     return CustomTextField(
//       controller: _websiteCtrl,
//       hint: AppStrings.WEBSITE,
//       validator: (value) => value?.validateEmpty(AppStrings.WEBSITE),
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
//       ],
//     );
//   }
//
//   Widget _addressTextField() {
//     return CustomTextField(
//       controller: _addressCtrl,
//       hint: AppStrings.ADDRESS,
//       validator: (value) => value?.validateEmpty(AppStrings.ADDRESS),
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
//       ],
//       // validator: (value) => value?.validateEmpty("Feedback"),
//       readOnly: true,
//       onTap: () async {
//         final Prediction? prediction = await Constants.addressPicker(context);
//         if (prediction != null) {
//           _addressCtrl.text = prediction.description ?? _addressCtrl.text;
//         }
//       },
//     );
//   }
//
//   Widget _userPreferredLanguageDropDown() {
//     return CustomSearchableDropDown(
//       dropDownData: languageNames,
//       hintText: AppStrings.PREFERRED_LANGUAGE,
//       prefix: SizedBox(width: 10.w),
//       horizontalPadding: 0,
//       selectedItems: preferredLanguage,
//       isMultiSelection: true,
//       showTags: true,
//       onChanged: (value) {
//         setState(() {
//           preferredLanguage = value;
//           buttonPressed = false;
//         });
//       },
//     );
//   }
//
//   Widget _businessPreferredLanguageDropDown() {
//     return CustomSearchableDropDown(
//       dropDownData: languageNames,
//       hintText: AppStrings.PREFERRED_LANGUAGE,
//       prefix: SizedBox(width: 10.w),
//       horizontalPadding: 0,
//       selectedItems: preferredLanguage,
//       isMultiSelection: true,
//       showTags: false,
//       onChanged: (value) {
//         int selectedIndex = 0;
//         String selectedCountryCode = "";
//
//         setState(() {
//           preferredLanguage = value;
//           buttonPressed = false;
//           for (int i = 0; i < (preferredLanguage?.length ?? 0); i++) {
//             setState(() {
//               selectedIndex = languageNames.indexOf(preferredLanguage![i]);
//               selectedCountryCode = countryCodes[selectedIndex];
//               countryCode?.add(selectedCountryCode);
//             });
//             print("selected index: ${selectedIndex}");
//             // print("complete profile: ${countryCodes}");
//             print("COuntry code: ${countryCode}");
//
//             // log("selectedIndex  $selectedIndex selecte /dCountryCode $selectedCountryCode country ${countryCodes[selectedIndex]}");
//
//             // log("Selected Country Code: ${selectedCountryCode}  langauge is $value i: ${preferredLanguage![i]}");
//             phoneTextField.add(LanguagesModel(
//               index: selectedIndex,
//               code: selectedCountryCode,
//               textField: [TextEditingController()],
//               language: value?[i],
//             ));
//           }
//         });
//       },
//     );
//   }
//
//   Widget _button() {
//     return CustomButton(
//       onTap: () {
//         setState(() {
//           buttonPressed = true;
//         });
//         if (_profileFormKey.currentState!.validate() &&
//             (preferredLanguage?.length ?? 0) > 0) {
//           _completeProfileApiMethod(context);
//           // if (_authRoleProvider?.role == AuthRole.business.name) {
//           //   AppNavigation.navigateTo(
//           //       context, AppRouteName.SUBSCRIPTION_PLAN_SCREEN_ROUTE,
//           //       arguments: true);
//           // } else {
//           //   AppNavigation.navigateTo(context, AppRouteName.MAIN_SCREEN_ROUTE,
//           //       arguments: MainScreenRoutingArgument(index: 1));
//           // }
//         }
//       },
//       text: AppStrings.CONTINUE,
//     );
//   }
//
//   Widget preferredLanguageError({bool? isVisible}) {
//     return Visibility(
//         visible: isVisible ?? false,
//         child: Align(
//           alignment: Alignment.topLeft,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 15, top: 5),
//             child: CustomText(
//               text: "Preferred language can't be empty",
//               fontColor: AppColors.THEME_COLOR_RED,
//               fontSize: 12,
//               fontFamily: AppFonts.Jost_Regular,
//             ),
//           ),
//         ));
//   }
//
//   // ------------ Complete Profile Api Call Method ------------------- //
//   void _completeProfileApiMethod(BuildContext context) {
//     print(_emailCtrl.text);
//
//     _completeProfileBloc.completeProfileBlocMethod(
//         context: context,
//         fullName: _nameCtrl.text,
//         companyName: _companyNameCtrl.text,
//         phoneNumber: phoneNumberController.text,
//         phoneCode: "+1",
//         countryCode: "US",
//         profileImage: imagePath,
//         address: _addressCtrl.text,
//         website: _websiteCtrl.text,
//         preferredLanguage: preferredLanguage,
//         preferredCountryCode:
//             _authRoleProvider?.role == AuthRole.user.name ? null : countryCode,
//         preferredPhoneCode: "+1", //[],
//         preferredPhoneNumber: "", //[],
//         role: _authRoleProvider?.role,
//         phoneNumberLength: phoneLength,
//         isEditProfile: false,
//         setProgressBar: () {
//           AppDialogs.progressAlertDialog(context: context);
//         });
//
//     // print("complete profile: ${countryCodes}");
//
//     print("ROLE : ${_authRoleProvider?.role}");
//   }
// }
