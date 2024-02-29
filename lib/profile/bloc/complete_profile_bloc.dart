import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:customer_service_provider_hybrid/auth/enums/auth_roles.dart';
import 'package:customer_service_provider_hybrid/profile/model/langauges_model.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/provider/company_details_provider.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../auth/model/user_model.dart';
import '../../auth/providers/user_provider.dart';
import '../../main_screen/routing_arguments/main_screen_routing_arguments.dart';
import '../../services/network/network.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_route_name.dart';
import 'package:path/path.dart' as getImagePath;

class CompleteprofileBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  UserResponseModel? _completeProfileResponse;
  User? _userData;
  UserProvider? _userProvider;
  String? imagePath;
  String? imageName;
  File? _userFileImage;
  GetCompanyDetailProvider? _companyDetailProvider;

  void completeProfileBlocMethod({
    required BuildContext context,
    String? fullName,
    String? companyName,
    String? phoneNumber,
    String? phoneCode,
    String? countryCode,
    String? profileImage,
    String? address,
    String? website,
    String? companyDescription,
    List? preferredLanguage,
    List? preferredCountryCode,
    List<LanguagesModel>? languagePhoneNumbersList,
    String? role,
    String? token,
    String? email,
    required VoidCallback setProgressBar,
    ValueChanged<dynamic>? updateProfile,
    int? phoneNumberLength,
    bool? isEditProfile = false,
  }) async {
    setProgressBar();

    //FORM DATA
    // Create a map to store the data
    Map<String, dynamic> formDataMap = {
      "full_name": fullName,
      "company_name": companyName,
      "phone_number": phoneNumber,
      "phone_code": phoneCode,
      "country_code": countryCode,
      "profile_image": profileImage,
      "address": address,
      "website": website,
      "email": email,
      "company_description": companyDescription,
    };

    if (preferredLanguage != null) {
      for (int i = 0; i < (preferredLanguage.length); i++) {
        formDataMap["preferred_language[$i]"] = preferredLanguage[i];

        if ((languagePhoneNumbersList?.length ?? 0) > 0) {
          for (int j = 0;
              j < (languagePhoneNumbersList![i].textField?.length ?? 0);
              j++) {
            formDataMap["preferred_phone_number[$i][$j]"] =
                languagePhoneNumbersList[i].textField?[j]?.text ?? "";
            formDataMap["preferred_country_code[$i][$j]"] =
                languagePhoneNumbersList[i].countryCode ?? "";
            formDataMap["preferred_phone_code[$i][$j]"] =
                languagePhoneNumbersList[i].phoneCode ?? "";
          }
        }
      }
    }

    if (profileImage != null) {
      _userFileImage = File(profileImage);
      imagePath = _userFileImage!.path;
      imageName = getImagePath.basename(_userFileImage!.path);
      formDataMap["profile_image"] =
          await MultipartFile.fromFile(imagePath!, filename: imageName);
    }

    formDataMap["role"] = role;

    _formData = FormData.fromMap(formDataMap);

    print({formDataMap});

    _onFailure = () {
      //log("Api Error:${_response.toString()}");
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(
        endPoint: NetworkStrings.COMPLETE_PROFILE_ENDPOINT, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _completeprofileResponseMethod(
        context: context,
        userEmail: companyName,
        fullName: fullName,
        role: role,
        isEditProfile: isEditProfile,
        updateProfile: updateProfile,
      );
    };
    _validateResponse();
  }

  //----------------------------------- Post Request -----------------------------------
  Future<void> _postRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().postRequest(
        endPoint: endPoint,
        formData: _formData,
        context: context,
        onFailure: _onFailure,
        isHeaderRequire: true);
  }

  //----------------------------------- Validate Response -----------------------------------
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  void _completeprofileResponseMethod({
    required BuildContext context,
    String? userEmail,
    String? fullName,
    String? role,
    bool? isEditProfile,
    ValueChanged<dynamic>? updateProfile,
  }) async {
    log("User Response:${_response?.data}");

    try {
      Logger().i("Complete Profile response method");
      //  _completeProfileResponse = _response?.data;
      _completeProfileResponse = UserResponseModel.fromJson(_response?.data);
      if (_completeProfileResponse != null) {
        //set user data in shared preference

        SharedPreference()
            .setUser(user: jsonEncode(_completeProfileResponse?.data));
        // SharedPreference()
        //     .setBearerToken(token: _completeProfileResponse?.token);

        //assign reference to user provider
        _userProvider = Provider.of<UserProvider>(context, listen: false);

        //set login response to user provider method
        _userProvider?.setCurrentUser(user: _completeProfileResponse?.data);

        if (role == AuthRole.user.name) {
          if (isEditProfile == true) {
            AppNavigation.navigatorPop(context);
          } else if (isEditProfile == false) {
            print("USER PROFILE COMPLETED");
            AppNavigation.navigateToRemovingAll(
              context,
              AppRouteName.MAIN_SCREEN_ROUTE,
              arguments: MainScreenRoutingArgument(
                index: 1,
              ),
            );
          }
        } else if (role == AuthRole.business.name) {
          print("PROFILE COMPLETED");
          if (isEditProfile == false) {
            AppNavigation.navigateTo(
                context, AppRouteName.SUBSCRIPTION_PLAN_SCREEN_ROUTE,
                arguments: true);
          } else if (isEditProfile == true) {
            log("Business edit profile data:${_response?.data}");

            _companyDetailProvider =
                Provider.of<GetCompanyDetailProvider>(context, listen: false);

            _companyDetailProvider?.updateCompanyDetailMethod(
                companyDetailResponse: _response?.data);

            print("USER PROFILE COMPLETED");
            AppNavigation.navigatorPop(context);
            /*    AppNavigation.navigateToRemovingAll(
              context,
              AppRouteName.MAIN_SCREEN_ROUTE,
              arguments: MainScreenRoutingArgument(
                index: 0,
              ),
            );*/
          }
        }
      }
    } catch (error) {
      print("Error:${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      // }
    }
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:customer_service_provider_hybrid/auth/enums/auth_roles.dart';
// import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
// import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';
//
// import '../../auth/model/user_model.dart';
// import '../../auth/providers/user_provider.dart';
// import '../../main_screen/routing_arguments/main_screen_routing_arguments.dart';
// import '../../services/network/network.dart';
// import '../../services/shared_preference.dart';
// import '../../utils/app_dialogs.dart';
// import '../../utils/app_route_name.dart';
// import 'package:path/path.dart' as getImagePath;
//
// class CompleteprofileBloc {
//   FormData? _formData;
//   Response? _response;
//   VoidCallback? _onSuccess, _onFailure;
//   UserResponseModel? _completeProfileResponse;
//   User? _userData;
//   UserProvider? _userProvider;
//   String? imagePath;
//   String? imageName;
//   File? _userFileImage;
//
//   void completeProfileBlocMethod({
//     required BuildContext context,
//     String? fullName,
//     String? companyName,
//     String? phoneNumber,
//     String? phoneCode,
//     String? countryCode,
//     String? profileImage,
//     String? address,
//     String? website,
//     List? preferredLanguage,
//     List? preferredCountryCode,
//     String? preferredPhoneCode,
//     dynamic preferredPhoneNumber,
//     String? role,
//     String? token,
//     required VoidCallback setProgressBar,
//     ValueChanged<dynamic>? updateProfile,
//     int? phoneNumberLength,
//     bool? isEditProfile = false,
//   }) async {
//     setProgressBar();
//     // AppDialogs.showToast(message: profileImage.toString());
//     //FORM DATA
//     // Create a map to store the data
//     Map<String, dynamic> formDataMap = {
//       "full_name": fullName,
//       "company_name": companyName,
//       "phone_number": phoneNumber,
//       "phone_code": phoneCode,
//       "country_code": countryCode,
//       "profile_image": profileImage,
//       "address": address,
//       "website": website,
//     };
//
//     if (preferredLanguage != null) {
//       for (int i = 0; i < (preferredLanguage.length); i++) {
//         formDataMap["preferred_language[$i]"] = preferredLanguage[i];
//       }
//     }
//
//     if (preferredCountryCode != null) {
//       print("inside loop");
//
//       int j = 0;
//       int k = 0;
//
//       print("phone length: ${phoneNumberLength}");
//       while (j < (preferredLanguage?.length ?? 0)) {
//         // j = 0 = Swadish AX
//         for (k = 0; k < (phoneNumberLength ?? 0); k++) {
//           // k = 0 j = 0 index = AX
//           formDataMap["preferred_country_code[$j][$k]"] =
//               preferredCountryCode[k];
//           formDataMap["preferred_phone_code[$j][$k]"] = preferredPhoneCode;
//           formDataMap["preferred_phone_number[$j][$k]"] =
//               "phoneTextField[j].textField?[k]";
//
//           print("[${j}], [${k}]");
//           print("${preferredCountryCode[k]}");
//         }
//         k = 0;
//         j++;
//       }
//     }
//
//     if (profileImage != null) {
//       _userFileImage = File(profileImage);
//       imagePath = _userFileImage!.path;
//       imageName = getImagePath.basename(_userFileImage!.path);
//       formDataMap["profile_image"] =
//           await MultipartFile.fromFile(imagePath!, filename: imageName);
//     }
//
//     formDataMap["role"] = role;
//
//     _formData = FormData.fromMap(formDataMap);
//
//     print({formDataMap});
//
//     // _formData = FormData.fromMap({
//     //   "full_name": fullName,
//     //   "company_name": companyName,
//     //   "phone_number": phoneNumber,
//     //   "phone_code": phoneCode,
//     //   "country_code": countryCode,
//     //   "profile_image": profile_image,
//     //   "address": address,
//     //   "website": website,
//     //   for (i = 0; i < (preferredLanguage?.length ?? 0); i++)
//     //     "preferred_language[i]": preferredLanguage?[i],
//     //   for (j = 0; j < (preferredCountryCode?.length ?? 0); j++)
//     //     "preferred_country_code[i][j]": preferredCountryCode?[i][j],
//     //   // "preferred_country_code": preferredCountryCode,
//     //   "preferred_phone_code": preferredPhoneCode,
//     //   "preferred_phone_number": preferredPhoneNumber,
//     //   "role": role,
//     // });
//
//     // print("Response" +
//     //     {
//     //       "full_name": fullName,
//     //       "company_name": companyName,
//     //       "phone_number": phoneNumber,
//     //       "phone_code": phoneCode,
//     //       "country_code": countryCode,
//     //       "profile_image": profile_image,
//     //       "address": address,
//     //       "website": website,
//     //       "preferred_language": preferredLanguage,
//     //       "preferred_country_code": preferredCountryCode,
//     //       "preferred_phone_code": preferredPhoneCode,
//     //       "preferred_phone_number": preferredPhoneNumber,
//     //       "role": role,
//     //     }.toString());
//
//     _onFailure = () {
//       //log("Api Error:${_response.toString()}");
//       AppNavigation.navigatorPop(context);
//     };
//
//     await _postRequest(
//         endPoint: NetworkStrings.COMPLETE_PROFILE_ENDPOINT, context: context);
//
//     _onSuccess = () {
//       AppNavigation.navigatorPop(context);
//       _completeprofileResponseMethod(
//         context: context,
//         userEmail: companyName,
//         fullName: fullName,
//         role: role,
//         isEditProfile: isEditProfile,
//         updateProfile: updateProfile,
//       );
//     };
//     _validateResponse();
//   }
//
//   //----------------------------------- Post Request -----------------------------------
//   Future<void> _postRequest(
//       {required String endPoint, required BuildContext context}) async {
//     _response = await Network().postRequest(
//         endPoint: endPoint,
//         formData: _formData,
//         context: context,
//         onFailure: _onFailure,
//         isHeaderRequire: true);
//   }
//
//   //----------------------------------- Validate Response -----------------------------------
//   void _validateResponse() {
//     if (_response != null) {
//       Network().validateResponse(
//           response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
//     }
//   }
//
//   void _completeprofileResponseMethod(
//       {required BuildContext context,
//       String? userEmail,
//       String? fullName,
//       String? role,
//       bool? isEditProfile, ValueChanged<dynamic>? updateProfile,}) async {
//     // try {
//     Logger().i("Complete Profile response method");
//     //  _completeProfileResponse = _response?.data;
//     _completeProfileResponse =
//         UserResponseModel.fromJson(await _response?.data);
//     print("response is " + _completeProfileResponse.toString());
//     log("response is hjhj" + _completeProfileResponse.toString());
//     log("is null: " + (_completeProfileResponse == null).toString());
//     log("API TOKEN: ${_completeProfileResponse?.token}");
//     if (_completeProfileResponse != null) {
//       //set user data in shared preference
//
//       log("in if clause");
//       SharedPreference().setUser(user: jsonEncode(_completeProfileResponse));
//       // SharedPreference()
//       //     .setBearerToken(token: _completeProfileResponse?.token);
//
//       //assign reference to user provider
//       _userProvider = Provider.of<UserProvider>(context, listen: false);
//
//       //set login response to user provider method
//       _userProvider?.setCurrentUser(user: _completeProfileResponse?.data);
//
//       log("USER PROVIDER: " + _userProvider.toString());
//
//       print("ROLE : ${role}");
//       if (role == AuthRole.user.name) {
//         if (isEditProfile == true) {
//           AppNavigation.navigatorPop(context);
//         } else if (isEditProfile == false) {
//           print("USER PROFILE COMPLETED");
//           AppNavigation.navigateToRemovingAll(
//             context,
//             AppRouteName.MAIN_SCREEN_ROUTE,
//             arguments: MainScreenRoutingArgument(
//               index: 1,
//             ),
//           );
//         }
//       } else if (role == AuthRole.business.name) {
//         print("PROFILE COMPLETED");
//         // AppNavigation.navigateToRemovingAll(
//         //   context,
//         //   AppRouteName.MAIN_SCREEN_ROUTE,
//         //   arguments: MainScreenRoutingArgument(
//         //     index: 0,
//         //   ),
//         // );
//       }
//     }
//     // } catch (error) {
//     //   AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
//     // }
//   }
// }
