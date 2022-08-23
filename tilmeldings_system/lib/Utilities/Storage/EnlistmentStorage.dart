import 'dart:io';

import 'package:tilmeldings_system/Models/Enlistment.dart';

import 'Storage.dart';

class MenuStorage extends Storage {
  const MenuStorage({required this.year, required this.week}) : super();

  final int year;
  final int week;

  @override
  Future<File> localFile() async {
    final path = "${await localPath()}/enlistment";

    Directory(path)
        .exists()
        .then((value) => !value ? Directory(path).create() : "");

    return File('$path/$year-$week');
  }

  Future<Enlistment> readEnlistment() async {
    final file = await localFile();
    final content = await file.readAsString();

    final enlistment = content
        .split("|")
        .take(5)
        .map(
            (e) =>
            e.compareTo("true") == 0 ? true :
            e.compareTo("false") == 0 ? false :
            throw Exception("Something went wrong in enlistment file, got $e"))
        .toList();

    return Enlistment(
        monday: enlistment[0],
        tuesday: enlistment[1],
        wednesday: enlistment[2],
        thursday: enlistment[3],
        friday: enlistment[4]
    );
  }

  Future<File> writeMenu(Enlistment enlistment) async {
    final file = await localFile();
    return file.writeAsString(enlistment.toString());
  }
}