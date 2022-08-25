import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tilmeldings_system/Models/StudentNotifier.dart';
import 'package:tilmeldings_system/Models/TokenNotifier.dart';
import 'package:tilmeldings_system/Pages/InitPage.dart';
import 'package:tilmeldings_system/Pages/LoginPage.dart';
import 'package:tilmeldings_system/Pages/StudentLoginPage.dart';
import 'package:tilmeldings_system/Pages/StudentRegistration.dart';
import 'package:tilmeldings_system/Pages/WeekPage.dart';
import 'package:tilmeldings_system/Utilities/Clients/HttpClient.dart';
import 'package:tilmeldings_system/Utilities/Clients/StudentClient.dart';
import 'package:tilmeldings_system/Utilities/Storage/TokenStorage.dart';
import 'package:tilmeldings_system/Utilities/util.dart';
import 'package:tilmeldings_system/Widgets/CupertinoAppWithRoutes.dart';

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



