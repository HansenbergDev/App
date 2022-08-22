import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../Models/StudentWeekData.dart';
import '../Utilities/util.dart';
import '../Utilities/Storage.dart';

class StudentWeekDataStorage extends Storage {
  StudentWeekDataStorage({required this.date});

  final DateTime date;

  @override
  Future<File> localFile() async {
    final path = await localPath();
    Directory("$path/week_data")
        .exists()
        .then((value) => !value ? Directory("$path/week_data").create() : "");

    return File('$path/week_data/${DateFormat("yyyy-MM-dd").format(date)}');
  }

  Future<StudentWeekData> readWeekData() async {
    final file = await localFile();
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
    final file = await localFile();
    return file.writeAsString(data.toString());
  }
}
