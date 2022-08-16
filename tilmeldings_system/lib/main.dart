import 'package:flutter/cupertino.dart';
import 'HomePage.dart';

void main() {
  runApp(const HansenbergApp());
}

class HansenbergApp extends StatelessWidget {
  const HansenbergApp({Key? key}) : super(key: key);

  final String _title = "This is a Cupertino App";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: _title, debugShowCheckedModeBanner: false, home: HomePage(studentName: "Elev",));
  }
}




