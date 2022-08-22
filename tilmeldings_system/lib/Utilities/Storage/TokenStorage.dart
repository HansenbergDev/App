import 'dart:io';

import 'Storage.dart';

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

  Future<File> writeToken(String token) async {
    final file = await localFile();
    return file.writeAsString(token);
  }
}