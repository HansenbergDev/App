import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tilmeldings_system/Models/TokenNotifier.dart';
import 'package:tilmeldings_system/Utilities/Storage/TokenStorage.dart';
import 'package:tilmeldings_system/Widgets/ActivityIndicatorWithTitle.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key, required this.tokenStorage}) : super(key: key);

  final TokenStorage tokenStorage;

  Future<String> _fetchToken() async {
    return await tokenStorage.tokenExists() ? await tokenStorage.readToken() : "";
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: FutureBuilder<String>(
          builder: (BuildContext futureContext, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {

              String token = snapshot.data!;

              if (token.isNotEmpty) {
                var split = snapshot.data!.split('|');
                var tokenNotifier = context.read<TokenNotifier>();

                if (split.first == 'student') {
                  Future.delayed(Duration.zero, () {
                    tokenNotifier.setToken(split.last.trim());
                    Navigator.of(context).pushReplacementNamed('/student/login');
                  });
                }
                else if (split.first == 'staff') {
                  Future.delayed(Duration.zero, () {
                    tokenNotifier.setToken(split.last.trim());
                    Navigator.of(context).pushReplacementNamed('/staff/login');
                  });
                }
                else {
                  throw Exception("Invalid token file");
                }
              }
              else {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pushReplacementNamed('/login');
                });
              }
            }
            else if (snapshot.hasError) {
              throw Exception("Something weird happened: ${snapshot.error}");
            }

            return const ActivityIndicatorWithTitle();
          },
          future: _fetchToken(),
        ),
    );
  }
}
