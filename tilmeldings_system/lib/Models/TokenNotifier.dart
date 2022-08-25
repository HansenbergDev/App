import 'package:flutter/cupertino.dart';

class TokenNotifier with ChangeNotifier {

  String? token;
  String? userType;

  void setToken(String t) {
    token = t;
    notifyListeners();
  }

  void setType(String t) {
    userType = t;
    notifyListeners();
  }
}