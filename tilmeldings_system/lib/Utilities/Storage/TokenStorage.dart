import 'dart:io';

import 'Storage.dart';

class TokenStorage extends Storage{

  @override
  Future<File> localFile() async {
    final path = await localPath();

    return File('$path/token');
  }

  Future<bool> tokenExists() async {
    return localFile().then((value) => value.exists());
  }

  Future<String> readToken() async {
    final file = await localFile();
    return await file.readAsString();
  }

  Future<File> writeToken(String token) async {
    final file = await localFile();
    return file.writeAsString(token);
  }
}