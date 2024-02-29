import 'package:customer_service_provider_hybrid/auth/model/user_model.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class Constants {
  static const EMAIL_MAX_LENGTH = 35;
  static const PASSWORD_MAX_LENGTH = 30;
  static const NAME_MAX_LENGTH = 30;
  static const DESCRIPTION_MAX_LENGTH = 275;
  static const ZIP_CODE_MAX_LENGTH = 7;
  static const CVC_LENGTH = 3;
  static const PHONE_NUMBER_LENGTH = 10;

  static const googleApiKey = "AIzaSyBmaS0B0qwokES4a_CiFNVkVJGkimXkNsk";

  static MaskTextInputFormatter MASK_TEXT_FORMATTER_CARD_NO =
  MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  static Future<Prediction?> addressPicker(BuildContext context) {
    return PlacesAutocomplete.show(
      offset: 0,
      logo: const Text(""),
      types: [],
      strictbounds: false,
      context: context,
      apiKey: googleApiKey,
      mode: Mode.overlay,
    );
  }

  static Future<Map<String, dynamic>> findStreetAreaMethod(
      {required BuildContext context, String? prediction}) async {
    Map<String, dynamic>? addressDetail = {
      "address": null,
      "city": null,
      "state": null
    };

    try {
      List? addressInArray = prediction?.split(",");
      print("Address in array:${addressInArray}");
      String address = "";
      if (addressInArray != null) {
        if (addressInArray.length == 1) {
          addressDetail["address"] = addressInArray[0];
        } else {
          for (int i = 0; i < addressInArray.length - 2; i++) {
            address = address + addressInArray[i];
          }
          print("Check the address:${addressDetail}");
          addressDetail["address"] = address;
          addressDetail["state"] =
          (addressInArray[addressInArray.length - 1] ?? "");
          addressDetail["city"] =
          (addressInArray[addressInArray.length - 2] ?? "");
        }
        print("Check the address:${addressDetail}");
      }
    } catch (e) {
      print("error:${e}");
    }
    return addressDetail;
  }

  static void callOnPhoneNumberMethod({String? phoneNumber}) {
    launchUrl(Uri.parse("tel://${phoneNumber}"));
  }

  static String joinPreferredLanguageText(
      {List<PreferredLanguages>? preferredLanguageList}) {
    List languageList = [];

    for (int i = 0; i < (preferredLanguageList?.length ?? 0); i++) {
      languageList.add(preferredLanguageList![i].languageName);
    }

    return languageList.join(" , ");
  }

  static String getCurrentTimeStamp() {
    return DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
  }


  //----------------- Launch Url -----------------//
  static void launchLink({String? url}) async {
    String _launchUrl;
    try {
      if (url != null) {
        _launchUrl = url.contains("https://") || url.contains("http://") ? url : "https://$url";
        await launchUrl(Uri.parse(_launchUrl),
            mode: LaunchMode.externalNonBrowserApplication);
      }
    } catch (e) {
      AppDialogs.showToast(message: "Could not launch url.");
    }
  }


  static void unFocusKeyboardMethod({required BuildContext context}) {
    FocusScope.of(context).unfocus();
  }
}