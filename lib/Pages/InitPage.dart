import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app/Utilities/DevelopingMode.dart';
import 'package:hansenberg_app/Utilities/Notifications.dart';
import 'package:hansenberg_app_core/Utilities/TokenStorage.dart';
import 'package:hansenberg_app/Widgets/ActivityIndicatorWithTitle.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key, required this.tokenStorage}) : super(key: key);

  final TokenStorage tokenStorage;

  Future<String> _fetchToken() async {

    if (DevelopingOptions.deleteOnInit) {
      await tokenStorage.deleteToken();
    }

    if (await tokenStorage.tokenExists()) {
      return await tokenStorage.readToken();
    }
    else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
        child: FutureBuilder<String>(
          builder: (BuildContext futureContext, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {

              if (DevelopingOptions().any((option) => option == true)) {
                Future.delayed(Duration.zero, () {
                  Notifications.showAlert(
                      context: context,
                      text: "Developing Mode enabled!",
                      duration: const Duration(seconds: 5)
                  );
                });
              }

              String token = snapshot.data!;

              if (token.isNotEmpty) {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pushReplacementNamed('/student/login');
                });
              }
              else {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pushReplacementNamed('/welcome');
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
