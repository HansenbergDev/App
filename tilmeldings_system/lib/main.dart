import 'package:flutter/cupertino.dart';
import 'package:tilmeldings_system/Pages/ChooseViewPage.dart';
import 'package:tilmeldings_system/Pages/HomePage.dart';
import 'package:tilmeldings_system/Pages/StudentRegistration.dart';

void main() {
  runApp(const HansenbergApp());
}

class HansenbergApp extends StatelessWidget {
  const HansenbergApp({Key? key}) : super(key: key);

  final String _title = "Hansenberg App";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TODO: Fetch from databse

    String studentName = "ElevNavn";
    return CupertinoApp(
      theme: const CupertinoThemeData(
        scaffoldBackgroundColor: CupertinoColors.secondarySystemBackground,
        brightness: Brightness.light,
      ),
      title: _title,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const ChooseViewPage(),
        '/student/home': (BuildContext context) => HomePage(studentName: studentName),
        '/student/login': (BuildContext context) => const CupertinoPageScaffold(child: Text("Student login")),
        '/student/registration': (BuildContext context) => const StudentRegistration(),
        '/staff/login': (BuildContext context) => const CupertinoPageScaffold(child: Text("Staff login")),
        '/staff/home': (BuildContext context) => const CupertinoPageScaffold(child: Text("Staff home")),
      },
    );
  }
}
