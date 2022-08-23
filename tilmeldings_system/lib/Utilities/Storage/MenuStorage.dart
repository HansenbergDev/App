import 'dart:io';

import 'package:tilmeldings_system/Models/Menu.dart';

import 'Storage.dart';

class MenuStorage extends Storage {
  const MenuStorage({required this.year, required this.week}) : super();

  final int year;
  final int week;

  @override
  Future<File> localFile() async {
    final path = "${await localPath()}/menu";

    Directory(path)
        .exists()
        .then((value) => !value ? Directory(path).create() : "");

    return File('$path/$year-$week');
  }

  Future<Menu> readMenu() async {
    final file = await localFile();
    final content = await file.readAsString();

    final menu = content.split("|").take(4).toList();

    return Menu(
        monday: menu[0],
        tuesday: menu[1],
        wednesday: menu[2],
        thursday: menu[3]
    );
  }

  Future<File> writeMenu(Menu menu) async {
    final file = await localFile();
    return file.writeAsString(menu.toString());
  }
}