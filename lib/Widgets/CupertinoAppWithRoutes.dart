import 'package:flutter/cupertino.dart';

class CupertinoAppWithRoutes extends StatelessWidget {
  const CupertinoAppWithRoutes({Key? key, required this.initialRoute, required this.routes, this.title}) : super(key: key);
  
  final String initialRoute;
  final Map<String, Widget Function(BuildContext)> routes;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(
        scaffoldBackgroundColor: CupertinoColors.secondarySystemBackground,
        brightness: Brightness.light,
      ),
      title: title == null ? "Hansenberg App" : title!,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}
