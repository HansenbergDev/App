import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tilmeldings_system/Models/TokenNotifier.dart';
import 'package:tilmeldings_system/Utilities/Storage/TokenStorage.dart';
import 'package:tilmeldings_system/Widgets/ActivityIndicatorWithTitle.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key, required this.tokenStorage}) : super(key: key);

  final TokenStorage tokenStorage;

  Future<Map<String, String>> _fetchTokenAndType() async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (await tokenStorage.tokenExists()) {
      String token = await tokenStorage.readToken();
      String userType = await tokenStorage.readTokenType();

      return <String, String> { 'token': token, 'userType': userType };
    }
    else {
      return <String, String> { };
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: FutureBuilder<Map<String, String>>(
          builder: (BuildContext futureContext, AsyncSnapshot<Map<String, String>> snapshot) {
            if (snapshot.hasData) {

              Map<String, String> map = snapshot.data!;

              if (map.isNotEmpty) {
                String userType = map['userType']!;
                String token = map['token']!;
                var tokenNotifier = context.read<TokenNotifier>();

                if (userType == 'student') {
                  Future.delayed(Duration.zero, () {
                    tokenNotifier.setToken(token);
                    Navigator.of(context).pushReplacementNamed('/student/login');
                  });
                }
                else if (userType == 'staff') {
                  Future.delayed(Duration.zero, () {
                    tokenNotifier.setToken(token);
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
          future: _fetchTokenAndType(),
        ),
    );
  }
}
