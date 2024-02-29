import 'dart:convert';
import 'dart:developer';

import 'package:customer_service_provider_hybrid/auth/enums/social_type.dart';
import 'package:customer_service_provider_hybrid/auth/model/user_model.dart';
import 'package:customer_service_provider_hybrid/profile/model/langauges_model.dart';
import 'package:customer_service_provider_hybrid/profile/widget/language_widget.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/app_fonts.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_phonenumber_txtfield.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_searchable_dropdown.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

import '../../auth/enums/auth_roles.dart';
import '../../auth/providers/auth_role_provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../utils/image_gallery_class.dart';
import '../../utils/regular_expressions.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_upload_image.dart';
import 'package:customer_service_provider_hybrid/utils/field_validator.dart';

import '../bloc/complete_profile_bloc.dart';
import 'package:collection/collection.dart';

class EditProfileScreen extends StatefulWidget {
  final ValueChanged<dynamic>? addCard;


  EditProfileScreen({Key? key, this.addCard}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _companyNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _companyDescriptionCtrl = TextEditingController();
  final _profileFormKey = GlobalKey<FormState>();
  User? _user;
  UserProvider? _userProvider;
  AuthRoleProvider? _authRoleProvider;
  List<String> preferredLanguage = [], _tempPreferredLanguage = [];

  bool? buttonPressed = false;
  TextEditingController phoneNumberController = TextEditingController();
  final _completeProfileBloc = CompleteprofileBloc();
  String? imagePath;
  bool? isFileImage = false;
  List<TextEditingController> _editPhoneNumberList = [];
  TextEditingController? _editingPhoneNumberController;

  @override
  void initState() {
    _userProvider = context.read<UserProvider>();
    _authRoleProvider = context.read<AuthRoleProvider>();
    readJson();
    _getUserData();
    buttonPressed = false;
    super.initState();
  }

  List<LanguagesModel> phoneTextField = [];

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
    return CustomAppTemplate(
      title: _authRoleProvider?.role == AuthRole.user.name
          ? AppStrings.PROFILE
          : AppStrings.EDIT_YOUR_PROFILE,
      child: _formWidget(),
    );
  }

  Widget _formWidget() {
    return CustomPadding(
      child: Form(
        key: _profileFormKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomSizeBox(height: 20.h),
                    _imageWidget(),
                    CustomSizeBox(height: 30.h),
                    _nameTextField(),
                    if (_authRoleProvider?.role == AuthRole.business.name) ...[
                      CustomSizeBox(),
                      _companyNameTextField(),
                    ],
                    _emailTextField(),
                    CustomSizeBox(),
                    phoneTxtField(),
                    CustomSizeBox(),
                    _addressTextField(),
                    if (_authRoleProvider?.role == AuthRole.business.name) ...[
                      CustomSizeBox(),
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
                            setState(() {
                              preferredLanguage.removeAt(index);
                              phoneTextField.removeAt(index);
                            });
                          },
                          onTapAdd: () {
                            setState(() {
                              phoneTextField[index].textField?.add(
                                TextEditingController(),
                              );
                            });
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: phoneTextField[index].textField?.length,
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
                                        code: countryCodes[languageNames
                                            .indexOf(preferredLanguage[index])],
                                        controller:
                                        phoneTextField[index].textField?[i],
                                        onTapSuffix: () {
                                          if (preferredLanguage.length != 0) {
                                            setState(() {
                                              buttonPressed = false;
                                            });
                                          }
                                          setState(() {
                                            phoneTextField[index]
                                                .textField
                                                ?.removeAt(i);
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
                      CustomSizeBox(),
                      _userPreferredLanguageDropDown(),
                    ],
                    preferredLanguageError(
                        isVisible: buttonPressed == true
                            ? preferredLanguage?.length == 0
                            ? true
                            : false
                            : false),
                    // preferredLanguageError(
                    //     isVisible:
                    //         preferredLanguage?.length == 0 ? true : false),
                    CustomSizeBox(),
                  ],
                ),
              ),
            ),
            _button(),
            CustomSizeBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return CustomUploadImage(
      imagePath: imagePath,
      isFileImage: isFileImage,
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
    return Visibility(
      visible: _authRoleProvider?.role == AuthRole.user.name && (_user?.userSocialType == SocialAuthType.google.name || _user?.userSocialType == SocialAuthType.apple.name) ? false : true,
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: CustomTextField(
          controller: _emailCtrl,
          hint: AppStrings.EMAIL_ADDRESS,
          keyboardType: TextInputType.emailAddress,
          readOnly: true,
          validator: (value) => value?.validateEmail,
          inputFormatters: [
            LengthLimitingTextInputFormatter(Constants.EMAIL_MAX_LENGTH)
          ],
        ),
      ),
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
      readOnly: true,
      validator: (value) => value?.validateEmpty(AppStrings.ADDRESS),
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
      ],
      // validator: (value) => value?.validateEmpty("Feedback"),
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
      onChanged: (value) {
        setState(() {
          preferredLanguage = value ?? [];
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
            print("loop");
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
              phoneData.language == _tempPreferredLanguage[z]);

              //print("Phone text field:${phoneTextField.length}");
            }
          }
        }

        setState(() {});
      },
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

  // phoneTxtField() {
  //   return PhoneNumberTextField(
  //     isEnabled: true,
  //     countryCode: AppStrings.defaultCountryCode,
  //     showDialogue: true,
  //     isReadOnly: false,
  //     controller: phoneNumberController,
  //     showDropDown: true,
  //     showFlag: true,
  //     isBorder: true,
  //     onchange: (value) async {
  //       return null;
  //     },
  //     backgroundColor: AppColors.THEME_COLOR_OFF_WHITE,
  //     validator: (value) async {
  //       return value?.completeNumber;
  //     },
  //   );
  // }

  Widget _languagesPhoneNumberTextField(
      {length, controller, onTapSuffix, code}) {
    return CustomTextField(
      suffixIcon: AssetPath.CROSS_ICON,
      isSuffixIcon: length == 0 ? false : true,
      suffixScale: 5.0,
      onTapSuffix: onTapSuffix,
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
        print("Auth Provider Role: ${_authRoleProvider?.role}");
        setState(() {
          buttonPressed = true;
        });

        if (_profileFormKey.currentState!.validate() &&
            (preferredLanguage?.length ?? 0) > 0) {
          _editProfileApiMethod(context);
          // AppDialogs.showToast(message: "Profile updated successfully");
          // AppNavigation.navigatorPop(context);
        }
      },
      text: AppStrings.SAVE,
    );
  }

  // ------------ Edit Profile Api Call Method ------------------- //
  void _editProfileApiMethod(BuildContext context) {
    Constants.unFocusKeyboardMethod(context: context);
    //if (widget.addCard != null) {
    _completeProfileBloc.completeProfileBlocMethod(
        context: context,
        fullName: _nameCtrl.text,
        companyName: _companyNameCtrl.text,
        phoneNumber: phoneNumberController.text,
        phoneCode: "+1",
        countryCode: "US",
        profileImage: isFileImage! ? imagePath : null,
        address: _addressCtrl.text,
        website: _websiteCtrl.text,
        preferredLanguage: preferredLanguage,
        preferredCountryCode: null,
        role: _authRoleProvider?.role,
        phoneNumberLength: 0,
        languagePhoneNumbersList: phoneTextField,
        companyDescription: _companyDescriptionCtrl.text,
        email: _emailCtrl.text,
        isEditProfile: true,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        });
    //widget.addCard!(true);
    //}
    // print("complete profile: ${countryCodes}");

    print("ROLE : ${_authRoleProvider?.role}");
  }

  void _getUserData() {
    if (_userProvider?.getCurrentUser != null) {
      log("in init");
      _user = _userProvider?.getCurrentUser;
      _getPreferredLanguage();
      imagePath = _user?.profileImage ?? null;
      _nameCtrl.text = _user?.fullName ?? "";
      _companyNameCtrl.text = _user?.companyName ?? "";
      _emailCtrl.text = _user?.email ?? "";
      phoneNumberController.text = _user?.phoneNumber ?? "";
      _addressCtrl.text = _user?.address ?? "";
      _websiteCtrl.text = _user?.website ?? "";
      _companyDescriptionCtrl.text = _user?.companyDescription ?? "";
      // preferredLanguage = (_user?.languages ?? []);
      //preferredLanguage = ["English (AS)"] ?? [];
    }
  }

  void _getPreferredLanguage() {
    print("New ${_authRoleProvider?.role}");
    //if (_authRoleProvider?.role == AuthRole.user.name) {

    for (int k = 0; k < (_user?.languages?.length ?? 0); k++) {
      _editPhoneNumberList = [];

      preferredLanguage.add(_user?.languages?[k].languageName ?? "");

      if (_authRoleProvider?.role == AuthRole.business.name) {
        for (int p = 0; p < (_user?.languages?[k].numbers?.length ?? 0); p++) {
          _editingPhoneNumberController = TextEditingController();
          _editingPhoneNumberController?.text =
              _user?.languages?[k].numbers?[p].phoneNumber ?? "";

          _editPhoneNumberList.add(_editingPhoneNumberController!);

          // _editPhoneNumberList.add(
          //
          // );
        }

        phoneTextField.add(LanguagesModel(
          index: k,
          countryCode: _editPhoneNumberList.length > 0
              ? _user!.languages![k].numbers![0].countryCode
              : "US",
          phoneCode: _editPhoneNumberList.length > 0
              ? _user!.languages![k].numbers![0].phoneCode
              : "+1",
          textField: _editPhoneNumberList,
          language: _user?.languages?[k].languageName ?? "",
        ));
      }
    }

    buttonPressed = true;
    // }
  }
}


// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:customer_service_provider_hybrid/auth/enums/social_type.dart';
// import 'package:customer_service_provider_hybrid/auth/model/user_model.dart';
// import 'package:customer_service_provider_hybrid/profile/model/langauges_model.dart';
// import 'package:customer_service_provider_hybrid/profile/widget/language_widget.dart';
// import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
// import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
// import 'package:customer_service_provider_hybrid/utils/app_fonts.dart';
// import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
// import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
// import 'package:customer_service_provider_hybrid/utils/constants.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_phonenumber_txtfield.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_searchable_dropdown.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:provider/provider.dart';
//
// import '../../auth/enums/auth_roles.dart';
// import '../../auth/providers/auth_role_provider.dart';
// import '../../auth/providers/user_provider.dart';
// import '../../utils/image_gallery_class.dart';
// import '../../utils/regular_expressions.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';
// import '../../widgets/custom_upload_image.dart';
// import 'package:customer_service_provider_hybrid/utils/field_validator.dart';
//
// import '../bloc/complete_profile_bloc.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   final ValueChanged<dynamic>? addCard;
//   EditProfileScreen({Key? key, this.addCard}) : super(key: key);
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _nameCtrl = TextEditingController();
//   final _companyNameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _addressCtrl = TextEditingController();
//   final _websiteCtrl = TextEditingController();
//   final _profileFormKey = GlobalKey<FormState>();
//   User? _user;
//   UserProvider? _userProvider;
//   AuthRoleProvider? _authRoleProvider;
//   List<String>? preferredLanguage = [];
//
//   bool? buttonPressed = false;
//   TextEditingController phoneNumberController = TextEditingController();
//   final _completeProfileBloc = CompleteprofileBloc();
//   String? imagePath;
//   bool? isFileImage = false;
//
//   @override
//   void initState() {
//     _userProvider = context.read<UserProvider>();
//     _authRoleProvider = context.read<AuthRoleProvider>();
//     readJson();
//     if (_userProvider?.getCurrentUser != null) {
//       log("in init");
//       _user = _userProvider?.getCurrentUser;
//       _getUserPreferredLanguage();
//       imagePath = _user?.profileImage ?? null;
//       _nameCtrl.text = _user?.fullName ?? "";
//       _companyNameCtrl.text = _user?.companyName ?? "";
//       _emailCtrl.text = _user?.email ?? "";
//       phoneNumberController.text = _user?.phoneNumber ?? "";
//       _addressCtrl.text = _user?.address ?? "";
//       _websiteCtrl.text = _user?.website ?? "";
//       // preferredLanguage = (_user?.languages ?? []);
//       preferredLanguage = ["English (US)", "Spanish (ES)"] ?? [];
//     }
//     buttonPressed = false;
//     super.initState();
//   }
//
//   List<LanguagesModel> phoneTextField = [];
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
//     return CustomAppTemplate(
//       title: _authRoleProvider?.role == AuthRole.user.name
//           ? AppStrings.PROFILE
//           : AppStrings.EDIT_YOUR_PROFILE,
//       child: _formWidget(),
//     );
//   }
//
//   Widget _formWidget() {
//     return CustomPadding(
//       child: Form(
//         key: _profileFormKey,
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     CustomSizeBox(height: 20.h),
//                     _imageWidget(),
//                     CustomSizeBox(height: 30.h),
//                     _nameTextField(),
//                     if (_authRoleProvider?.role == AuthRole.business.name) ...[
//                       CustomSizeBox(),
//                       _companyNameTextField(),
//                     ],
//                     if(_authRoleProvider?.role == AuthRole.business.name) ...[
//                       CustomSizeBox(),
//                       _emailTextField(),
//                     ]
//                     else if(_authRoleProvider?.role == AuthRole.user.name) ...[
//                       if(_user?.userSocialType == SocialAuthType.google.name) ...[
//                         SizedBox(),
//                       ]
//                       else ...[
//                         CustomSizeBox(),
//                         _emailTextField(),
//                       ]
//                     ],
//                     CustomSizeBox(),
//                     phoneTxtField(),
//                     CustomSizeBox(),
//                     _addressTextField(),
//                     if (_authRoleProvider?.role == AuthRole.business.name) ...[
//                       CustomSizeBox(),
//                       _websiteTextField(),
//                       CustomSizeBox(
//                           // height: 7.h,
//                           ),
//                       _businessPreferredLanguageDropDown(),
//                       ...List.generate(
//                         (preferredLanguage!.length),
//                         (index) => LanguageWidget(
//                           text: preferredLanguage![index],
//                           onTapDelete: () {
//                             setState(() {
//                               preferredLanguage!.removeAt(index);
//                             });
//                           },
//                           onTapAdd: () {
//                             setState(() {
//                               phoneTextField[index].textField?.add(
//                                     TextEditingController(),
//                                   );
//                             });
//                           },
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: phoneTextField[index].textField?.length,
//                             itemBuilder: ((context, i) {
//                               // log("phoneTextField[index].code  ${phoneTextField[index].code}  ${countryCodes[index]}");
//                               return Row(
//                                 children: [
//                                   // Text("${countryCodes[languageNames.indexOf(preferredLanguage![index])]??""}"),
//                                   Expanded(
//                                     child: Padding(
//                                       padding: EdgeInsets.only(bottom: 10.h),
//                                       child: _languagesPhoneNumberTextField(
//                                         length: i,
//                                         code: countryCodes[
//                                             languageNames.indexOf(
//                                                 preferredLanguage![index])],
//                                         controller:
//                                             phoneTextField[index].textField?[i],
//                                         onTapSuffix: () {
//                                           if (preferredLanguage!.length != 0) {
//                                             setState(() {
//                                               buttonPressed = false;
//                                             });
//                                           }
//                                           setState(() {
//                                             phoneTextField[index]
//                                                 .textField
//                                                 ?.removeAt(i);
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }),
//                           ),
//                         ),
//                       ),
//                     ] else ...[
//                       CustomSizeBox(),
//                       _userPreferredLanguageDropDown(),
//                     ],
//                     preferredLanguageError(
//                         isVisible: buttonPressed == true
//                             ? preferredLanguage?.length == 0
//                                 ? true
//                                 : false
//                             : false),
//                     // preferredLanguageError(
//                     //     isVisible:
//                     //         preferredLanguage?.length == 0 ? true : false),
//                     CustomSizeBox(),
//                   ],
//                 ),
//               ),
//             ),
//             _button(),
//             CustomSizeBox(height: 15.h),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _imageWidget() {
//     return CustomUploadImage(
//       imagePath: imagePath,
//       isFileImage: isFileImage,
//       onTap: () {
//         ImageGalleryClass().imageGalleryBottomSheet(
//           context: context,
//           onMediaChanged: (value) {
//             setState(() {
//               imagePath = value!;
//               isFileImage = true;
//               print("This is image ${imagePath}");
//             });
//           },
//         );
//       },
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
//       readOnly: true,
//       validator: (value) => value?.validateEmpty(AppStrings.ADDRESS),
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
//       ],
//       // validator: (value) => value?.validateEmpty("Feedback"),
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
//         setState(() {
//           preferredLanguage = value;
//           for (int i = 0; i < (preferredLanguage?.length ?? 0); i++) {
//             setState(() {
//               selectedIndex = languageNames.indexOf(preferredLanguage![i]);
//               selectedCountryCode = countryCodes[selectedIndex];
//             });
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
//   Widget _languagesPhoneNumberTextField(
//       {length, controller, onTapSuffix, code}) {
//     return CustomTextField(
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
//   Widget _button() {
//     return CustomButton(
//       onTap: () {
//         print("Auth Provider Role: ${_authRoleProvider?.role}");
//         setState(() {
//           buttonPressed = true;
//         });
//
//         if (_profileFormKey.currentState!.validate() &&
//             (preferredLanguage?.length ?? 0) > 0) {
//           _editProfileApiMethod(context);
//           // AppDialogs.showToast(message: "Profile updated successfully");
//           // AppNavigation.navigatorPop(context);
//         }
//       },
//       text: AppStrings.SAVE,
//     );
//   }
//
//   _getUserPreferredLanguage() {
//     print("New ${_authRoleProvider?.role}");
//     if (_authRoleProvider?.role == AuthRole.user.name) {
//       preferredLanguage = ["English (US)", "Spanish (ES)"];
//
//       buttonPressed = true;
//     }
//   }
//
//   // ------------ Edit Profile Api Call Method ------------------- //
//   void _editProfileApiMethod(BuildContext context) {
//     print(_emailCtrl.text);
//     print("This is image on button ${imagePath}");
//     if (widget.addCard != null) {
//       _completeProfileBloc.completeProfileBlocMethod(
//           context: context,
//           fullName: _nameCtrl.text,
//           companyName: _companyNameCtrl.text,
//           phoneNumber: phoneNumberController.text,
//           phoneCode: "+1",
//           countryCode: "US",
//           profileImage: isFileImage! ? imagePath : null,
//           address: _addressCtrl.text,
//           website: _websiteCtrl.text,
//           preferredLanguage: preferredLanguage,
//           preferredCountryCode:
//               _authRoleProvider?.role == AuthRole.user.name ? null : [],
//           preferredPhoneCode: "+1", //[],
//           preferredPhoneNumber: "", //[],
//           role: _authRoleProvider?.role,
//           phoneNumberLength: 0,
//           isEditProfile: true,
//           setProgressBar: () {
//             AppDialogs.progressAlertDialog(context: context);
//           });
//       widget.addCard!(true);
//     }
//     // print("complete profile: ${countryCodes}");
//
//     print("ROLE : ${_authRoleProvider?.role}");
//   }
// }
