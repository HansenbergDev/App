import 'package:flutter/cupertino.dart';
import 'package:tilmeldings_system/Models/Student.dart';

class StudentNotifier with ChangeNotifier {

  Student? student;

  void set(Student s) {
    student = s;
    notifyListeners();
  }
}