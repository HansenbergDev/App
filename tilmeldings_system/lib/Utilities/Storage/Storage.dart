// import 'dart:io';
//
// import 'package:path_provider/path_provider.dart';
//
// abstract class Storage {
//   const Storage();
//
//   Future<String> localPath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }
//
//   Future<File> localFile();
// }