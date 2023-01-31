import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app/Models/StudentNotifier.dart';
import 'package:hansenberg_app/Pages/InitPage.dart';
import 'package:hansenberg_app/Pages/StudentLoginPage.dart';
import 'package:hansenberg_app/Pages/StudentPage.dart';
import 'package:hansenberg_app/Pages/StudentRegistration.dart';
import 'package:hansenberg_app/Pages/WelcomePage.dart';
import 'package:hansenberg_app_core/Utilities/Clients/EnlistmentClient.dart';
import 'package:hansenberg_app_core/Utilities/Clients/HttpClient.dart';
import 'package:hansenberg_app_core/Utilities/Clients/MenuClient.dart';
import 'package:hansenberg_app_core/Utilities/Clients/StudentClient.dart';
import 'package:hansenberg_app_core/Utilities/TokenStorage.dart';
import 'package:hansenberg_app/Widgets/CupertinoAppWithRoutes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StudentNotifier(),
        ),
      ],
      child: const HansenbergApp(),
    )
  );
}


class HansenbergApp extends StatefulWidget {
  const HansenbergApp({Key? key}) : super(key: key);

  @override
  State<HansenbergApp> createState() => _HansenbergAppState();
}

class _HansenbergAppState extends State<HansenbergApp> {

  @override
  Widget build(BuildContext context) {

    String protocol = 'http://';
    String ip = '143.244.196.82';
    // String ip = "10.0.2.2";
    String port = '4001';
    String api = '/api/1.0';

    String uri = "$protocol$ip:$port$api";

    TokenStorage tokenStorage = TokenStorage();

    HttpClient httpClient = HttpClient(base: uri);

    StudentClient studentClient = StudentClient(httpClient: httpClient);
    MenuClient menuClient = MenuClient(httpClient: httpClient);
    EnlistmentClient enlistmentClient = EnlistmentClient(httpClient: httpClient);

    return CupertinoAppWithRoutes(
        initialRoute: '/',
        routes: <String, WidgetBuilder> {
          '/': (BuildContext context) => InitPage(tokenStorage: tokenStorage),
          '/welcome': (BuildContext context) => const WelcomePage(),
          '/student': (BuildContext context) =>
              StudentPage(
                menuClient: menuClient,
                enlistmentClient: enlistmentClient,
                studentClient: studentClient,
                tokenStorage: tokenStorage,
              ),
          '/student/login': (BuildContext context) =>
              StudentLoginPage(
                  studentClient: studentClient,
                  tokenStorage: tokenStorage
              ),
          '/student/registration': (BuildContext context) =>
              StudentRegistration(
                  studentClient: studentClient,
                  tokenStorage: tokenStorage
              ),
        });
  }
}



