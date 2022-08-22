import 'dart:io';

import '../Utilities/Storage.dart';

class TokenStorage extends Storage{

  @override
  Future<File> localFile() async {
    final path = await localPath();

    return File('$path/token');
  }

  Future<String> readToken() async {
    final file = await localFile();
    final token = await file.readAsString();

    return token;
  }
}