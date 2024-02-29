import 'package:flutter/material.dart';

class AuthRoleProvider extends ChangeNotifier {
  String? _role;
  String? get role => _role;

  setRole({required String? role}) {
    _role = role;
    notifyListeners();
  }

  clear() {
    _role = null;
  }
}
