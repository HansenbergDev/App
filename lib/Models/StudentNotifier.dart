import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app_core/Models/Student.dart';

class StudentNotifier with ChangeNotifier {

  Student? student;

  void set(Student s) {
    student = s;
    notifyListeners();
  }
}