// import 'package:flutter/material.dart';
//
// class LanguagesModel {
//   List<TextEditingController?>? textField;
//   String? language;
//   int? index;
//   String? code;
//   LanguagesModel({this.textField, this.language,this.code,this.index});
// }

import 'package:flutter/material.dart';

class LanguagesModel {
  List<TextEditingController?>? textField;
  String? language;
  int? index;
  String? countryCode,phoneCode;
  LanguagesModel({this.textField, this.language,this.countryCode,this.phoneCode,this.index});
}
