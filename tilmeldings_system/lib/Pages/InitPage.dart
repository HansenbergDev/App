import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tilmeldings_system/Models/TokenNotifier.dart';
import 'package:tilmeldings_system/Utilities/Storage/TokenStorage.dart';
import 'package:tilmeldings_system/Widgets/ActivityIndicatorWithTitle.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key, required this.storage}) : super(key: key);

  final TokenStorage storage;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: FutureBuilder<String>(
          builder: (BuildContext futureContext, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              var split = snapshot.data!.split('|');
              var tokenNotifier = context.read<TokenNotifier>();

              if (split.first.compareTo('student') == 0) {
                Future.delayed(Duration.zero, () {
                  tokenNotifier.setToken(split.last.trim());
                  Navigator.of(context).pushReplacementNamed('/student/login');
                });

                return const ActivityIndicatorWithTitle();
              }
              else if (split.first.compareTo('staff') == 0) {
                Future.delayed(Duration.zero, () {
                  tokenNotifier.setToken(split.last.trim());
                  Navigator.of(context).pushReplacementNamed('/staff/login');
                });

                return const ActivityIndicatorWithTitle();
              }
              else {
                throw Exception("Invalid token file");
              }
            }
            else if (snapshot.hasError) {
              if (snapshot.error.runtimeType == FileSystemException) {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pushReplacementNamed('/login');
                });
                return const ActivityIndicatorWithTitle();
              }
              else {
                throw Exception("Something weird happened: ${snapshot.error}");
              }
            }
            else {
              return const ActivityIndicatorWithTitle();
            }
          },
          future: storage.readToken(),
        ),
    );
  }
}
