import 'dart:convert';

import 'package:flutter/material.dart';

import '../../services/shared_preference.dart';
import '../model/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;

  ///getters

  User? get getCurrentUser => _currentUser;

  /// setters

  void setCurrentUser({User? user}) {
    if (user != null) {
      print("Set Current USer");
      _currentUser = user;
    } else {
      _currentUser = null;
    }
    notifyListeners();
  }





  void disposeCurrentUser() {
    _currentUser = null;
  }

  void clearCurrentUser() {
    _currentUser = null;
  }
}
