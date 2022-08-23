import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../Models/StudentWeekData.dart';
import '../util.dart';
import 'Storage.dart';

class StudentWeekDataStorage extends Storage {
  const StudentWeekDataStorage({required this.date});

  final DateTime date;

  @override
  Future<File> localFile() async {
    final path = "${await localPath()}/week_data";

    Directory(path)
        .exists()
        .then((value) => !value ? Directory(path).create() : "");

    return File('$path/${DateFormat("yyyy-MM-dd").format(date)}');
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
