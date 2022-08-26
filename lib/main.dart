import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:hansenberg_app/Models/StudentNotifier.dart';
import 'package:hansenberg_app/Models/TokenNotifier.dart';
import 'package:hansenberg_app/Pages/InitPage.dart';
import 'package:hansenberg_app/Pages/LoginPage.dart';
import 'package:hansenberg_app/Pages/StudentLoginPage.dart';
import 'package:hansenberg_app/Pages/StudentRegistration.dart';
import 'package:hansenberg_app/Pages/WeekPage.dart';
import 'package:hansenberg_app/Utilities/Clients/HttpClient.dart';
import 'package:hansenberg_app/Utilities/Clients/StudentClient.dart';
import 'package:hansenberg_app/Utilities/Storage/TokenStorage.dart';
import 'package:hansenberg_app/Utilities/util.dart';
import 'package:hansenberg_app/Widgets/CupertinoAppWithRoutes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TokenNotifier(),
        ),
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
  // final String uriBase = "http://10.0.2.2:4001";

  final String uriBase = "http://178.62.220.90:4001";

  @override
  Widget build(BuildContext context) {

    TokenStorage tokenStorage = TokenStorage();

    HttpClient httpClient = HttpClient(base: uriBase);

    StudentClient studentClient = StudentClient(
        httpClient: httpClient
    );

    return CupertinoAppWithRoutes(
        initialRoute: '/',
        routes: <String, WidgetBuilder> {
          '/': (BuildContext context) => InitPage(tokenStorage: tokenStorage),
          '/login': (BuildContext context) => const LoginPage(),
          '/student': (BuildContext context) => MainPage(httpClient: httpClient,userType: UserTypes.student,),
          '/student/login': (BuildContext context) => StudentLoginPage(studentClient: studentClient),
          '/student/registration': (BuildContext context) => StudentRegistration(studentClient: studentClient, tokenStorage: tokenStorage),
          '/staff/login': (BuildContext context) => MainPage(httpClient: httpClient, userType: UserTypes.staff),
          '/staff': (BuildContext context) => const CupertinoPageScaffold(child: Text("Staff home")),
        });
  }
}



