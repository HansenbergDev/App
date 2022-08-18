import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../Models/StudentWeekData.dart';
import '../Utilities/util.dart';

class StudentWeekDataStorage {
  const StudentWeekDataStorage({required this.date});

  final DateTime date;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    Directory("$path/week_data")
        .exists()
        .then((value) => !value ? Directory("$path/week_data").create() : "");

    return File('$path/week_data/${DateFormat("yyyy-MM-dd").format(date)}');
  }

  Future<StudentWeekData> readWeekData() async {
    final file = await _localFile;
    final content = await file.readAsString();

    final days = content.split(';').take(5).toList();

    return StudentWeekData(
        menu: days.map((day) => day.split('|').first).toList(),
        states: days.map(
                (day) => EnlistmentStates.values.firstWhere(
                        (state) => describeEnum(state)
                            .compareTo(day.split('|').last) == 0))
            .toList()
    );
  }

  Future<File> writeWeekData(StudentWeekData data) async {
    final file = await _localFile;
    return file.writeAsString(data.toString());
  }
}
