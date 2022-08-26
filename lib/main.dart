import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app/Models/StudentNotifier.dart';
import 'package:hansenberg_app/Pages/InitPage.dart';
import 'package:hansenberg_app/Pages/StudentLoginPage.dart';
import 'package:hansenberg_app/Pages/StudentPage.dart';
import 'package:hansenberg_app/Pages/StudentRegistration.dart';
import 'package:hansenberg_app/Pages/WelcomePage.dart';
import 'package:hansenberg_app/Utilities/Clients/HttpClient.dart';
import 'package:hansenberg_app/Utilities/Clients/StudentClient.dart';
import 'package:hansenberg_app/Utilities/Storage/TokenStorage.dart';
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
    // String ip = '178.62.220.90';
    String ip = "10.0.2.2";
    String port = '4001';
    String api = '/api/1.0';

    String uri = "$protocol$ip:$port$api";

    TokenStorage tokenStorage = TokenStorage();

    HttpClient httpClient = HttpClient(base: uri);

    StudentClient studentClient = StudentClient(
        httpClient: httpClient
    );

    return CupertinoAppWithRoutes(
        initialRoute: '/',
        routes: <String, WidgetBuilder> {
          '/': (BuildContext context) => InitPage(tokenStorage: tokenStorage),
          '/welcome': (BuildContext context) => const WelcomePage(),
          '/student': (BuildContext context) => StudentPage(httpClient: httpClient,),
          '/student/login': (BuildContext context) => StudentLoginPage(studentClient: studentClient),
          '/student/registration': (BuildContext context) => StudentRegistration(studentClient: studentClient, tokenStorage: tokenStorage),
        });
  }
}



