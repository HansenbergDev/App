import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app/Utilities/DevelopingMode.dart';
import 'package:hansenberg_app/Utilities/Notifications.dart';
import 'package:hansenberg_app_core/Utilities/TokenStorage.dart';
import 'package:hansenberg_app_core/Widgets/ActivityIndicatorWithTitle.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key, required this.tokenStorage}) : super(key: key);

  final TokenStorage tokenStorage;

  //TODO: Det burde være nok at returnere en Bool her, ingen grund til faktisk at læse token, da det ikke bliver brugt her
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
              throw Exception("Something happened: ${snapshot.error}");
            }

            return const ActivityIndicatorWithTitle();
          },
          future: _fetchToken(),
        ),
    );
  }
}
