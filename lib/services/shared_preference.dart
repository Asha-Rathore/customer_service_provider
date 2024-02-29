import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_strings.dart';

class SharedPreference {
  static SharedPreference? _sharedPreferenceHelper;
  static SharedPreferences? _sharedPreferences;

  SharedPreference._createInstance();

  factory SharedPreference() {
    // factory with constructor, return some value
    if (_sharedPreferenceHelper == null) {
      _sharedPreferenceHelper = SharedPreference
          ._createInstance(); // This is executed only once, singleton object
    }
    return _sharedPreferenceHelper!;
  }

  Future<SharedPreferences> get sharedPreference async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
    return _sharedPreferences!;
  }

  void clear() {
    _sharedPreferences?.clear();
  }

  void setBearerToken({String? token}) {
    _sharedPreferences?.setString(AppStrings.BEARER_TOKEN_KEY, token ?? "");
  }

  String? getBearerToken() {
    return _sharedPreferences?.getString(AppStrings.BEARER_TOKEN_KEY);
  }

  void setUser({String? user}) {
    print("Set user inside shared run");
    _sharedPreferences?.setString(AppStrings.USER_DATA_KEY, user ?? "");
  }

  String? getUser() {
    return _sharedPreferences?.getString(AppStrings.USER_DATA_KEY);
  }

  ////////////////////// Notification Message Id ///////////////////////////
  void setNotificationMessageId({String? messageId}) {
    _sharedPreferences!
        .setString(AppStrings.NOTIFICATION_MESSAGE_ID_KEY, messageId ?? "");
  }

  String? getNotificationMessageId() {
    return _sharedPreferences!
        .getString(AppStrings.NOTIFICATION_MESSAGE_ID_KEY);
  }
}
