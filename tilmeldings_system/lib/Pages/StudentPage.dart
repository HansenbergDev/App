import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tilmeldings_system/Models/StudentNotifier.dart';
import 'package:tilmeldings_system/Utilities/Clients/EnlistmentClient.dart';
import 'package:tilmeldings_system/Utilities/Clients/HttpClient.dart';
import 'package:tilmeldings_system/Utilities/Clients/MenuClient.dart';
import 'package:week_of_year/date_week_extensions.dart';

import 'StudentWeekPage.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({
    Key? key,
    required this.httpClient
  }) : super(key: key);

  final HttpClient httpClient;

  String _initialRoute() {
    DateTime now = DateTime.now();
    return "${now.weekOfYear}";
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final week = int.parse(settings.name!);

    final now = DateTime.now();

    final difference = 7 * (week - now.weekOfYear);

    final next = now.add(Duration(days: difference));

    final mondayOfWeek = next.subtract(Duration(days: next.weekday - 1));

    WidgetBuilder builder;

    builder = (BuildContext context) => StudentWeekPage(
      mondayOfWeek: mondayOfWeek,
      menuClient: MenuClient(httpClient: httpClient),
      enlistmentClient: EnlistmentClient(httpClient: httpClient),
    );

    return PageRouteBuilder(pageBuilder: (BuildContext context, _, __) => builder(context));
    // return CupertinoPageRoute(builder: builder, settings: settings);
  }

  @override
  Widget build(BuildContext context) {

    var studentName = context.select<StudentNotifier, String>(
          (notifier) => notifier.student!.studentName,
    );

    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.secondarySystemBackground,
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            // TODO: Implement menu
            onPressed: () => print("Menu"),
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.bars),
          ),
          middle: Text("Hej $studentName!"),
          trailing: CupertinoButton(
            // TODO: Implement chat
            onPressed: () => print("Chat"),
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.chat_bubble_text),
          ),
        ),
        child: Navigator(
          initialRoute: _initialRoute(),
          onGenerateRoute: (RouteSettings settings) => _onGenerateRoute(settings),
        ));
  }
}
