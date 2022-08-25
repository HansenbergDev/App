import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tilmeldings_system/Models/StudentNotifier.dart';
import 'package:tilmeldings_system/Pages/StaffWeekPage.dart';
import 'package:tilmeldings_system/Utilities/Clients/EnlistmentClient.dart';
import 'package:tilmeldings_system/Utilities/Clients/HttpClient.dart';
import 'package:tilmeldings_system/Utilities/Clients/MenuClient.dart';
import 'package:tilmeldings_system/Utilities/Clients/StudentClient.dart';
import 'package:tilmeldings_system/Utilities/util.dart';
import 'package:week_of_year/date_week_extensions.dart';

import 'StudentWeekPage.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
    required this.httpClient,
    required this.userType
  }) : super(key: key);

  final HttpClient httpClient;
  final UserTypes userType;

  String initialRoute() {
    DateTime now = DateTime.now();
    return "${now.weekOfYear}";
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final week = int.parse(settings.name!);

    final now = DateTime.now();

    final difference = 7 * (week - now.weekOfYear);

    final next = now.add(Duration(days: difference));

    final mondayOfWeek = next.subtract(Duration(days: next.weekday - 1));

    WidgetBuilder builder;

    if (userType == UserTypes.student) {
      builder = (BuildContext context) => StudentWeekPage(
        mondayOfWeek: mondayOfWeek,
        menuClient: MenuClient(httpClient: httpClient),
        enlistmentClient: EnlistmentClient(httpClient: httpClient),
      );
    }
    else if (userType == UserTypes.staff) {
      builder = (BuildContext context) => StaffWeekPage(
        mondayOfWeek: mondayOfWeek,
        menuClient: MenuClient(httpClient: httpClient),
        enlistmentClient: EnlistmentClient(httpClient: httpClient),
      );
    }
    else {
      throw Exception("Invalid user type");
    }

    return PageRouteBuilder(pageBuilder: (BuildContext context, _, __) => builder(context));
  }

  void showActionSheet(BuildContext context, {required List<CupertinoActionSheetAction> actions} ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Indstillinger', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        // message: const Text('Message'),
        actions: actions,
      ),
    );
  }

  Future _deleteUser() async {
    final prefs = await SharedPreferences.getInstance();

    if (userType == UserTypes.student) {
      StudentClient client = StudentClient(httpClient: httpClient);
      client.deleteStudent(prefs.getString('token')!);
    }

    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {

    String userName = "";

    if (userType == UserTypes.student) {
      userName = context.select<StudentNotifier, String>(
            (notifier) => notifier.student!.studentName,
      );
    }

    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.secondarySystemBackground,
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            onPressed: () => showActionSheet(
                context,
                actions: <CupertinoActionSheetAction> [
                  CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () async {
                      await _deleteUser();
                      Future.delayed(Duration.zero, () {
                        Navigator.pushReplacementNamed(context, '/');
                      });
                    },
                    child: const Text('Slet bruger!'),
                  )
                ]
            ),
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.gear, size: 30,),
          ),
          middle: userName.isNotEmpty ? Text("Hej $userName!") : null,
          trailing: CupertinoButton(
            // TODO: Implement chat
            onPressed: () => print("Chat"),
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.chat_bubble_text, size: 30),
          ),
        ),
        child: Navigator(
          initialRoute: initialRoute(),
          onGenerateRoute: (RouteSettings settings) => onGenerateRoute(settings),
        )
    );
  }
}
