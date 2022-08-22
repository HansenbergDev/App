import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tilmeldings_system/Models/StudentNotifier.dart';
import 'package:tilmeldings_system/Models/TokenNotifier.dart';
import 'package:tilmeldings_system/Pages/LoginPage.dart';
import 'package:tilmeldings_system/Pages/InitPage.dart';
import 'package:tilmeldings_system/Pages/StudentLoginPage.dart';
import 'package:tilmeldings_system/Pages/StudentPage.dart';
import 'package:tilmeldings_system/Pages/StudentRegistration.dart';
import 'package:tilmeldings_system/Utilities/Clients/StudentClient.dart';
import 'package:tilmeldings_system/Utilities/Storage/TokenStorage.dart';
import 'package:tilmeldings_system/Widgets/CupertinoAppWithRoutes.dart';
import 'package:tilmeldings_system/Utilities/Clients/HttpClient.dart';

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

  // final String uriBase = "http://localhost:4001";
  final String uriBase = "http://10.0.2.2:4001";

  @override
  Widget build(BuildContext context) {

    StudentClient studentClient = StudentClient(
        httpClient: HttpClient(
            base: uriBase
        )
    );

    return CupertinoAppWithRoutes(
        initialRoute: '/',
        routes: <String, WidgetBuilder> {
          '/': (BuildContext context) => InitPage(storage: TokenStorage()),
          '/login': (BuildContext context) => const LoginPage(),
          '/student': (BuildContext context) => const StudentPage(),
          '/student/login': (BuildContext context) => StudentLoginPage(studentClient: studentClient),
          '/student/registration': (BuildContext context) => StudentRegistration(studentClient: studentClient, storage: TokenStorage()),
          '/staff/login': (BuildContext context) => const CupertinoPageScaffold(child: Text("Staff login")),
          '/staff': (BuildContext context) => const CupertinoPageScaffold(child: Text("Staff home")),
        });
  }
}


