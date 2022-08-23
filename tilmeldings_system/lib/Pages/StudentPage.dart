import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tilmeldings_system/Models/StudentNotifier.dart';

import '../Utilities/Storage/StudentWeekDataStorage.dart';
import 'StudentWeekPage.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({Key? key}) : super(key: key);

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
          initialRoute: 'mondayOfWeek/${DateFormat("yyyy-MM-dd").format(DateTime.now())}',
          onGenerateRoute: (RouteSettings settings) {
            var splitRoute = settings.name.toString().split('/');

            if (splitRoute[0].compareTo('mondayOfWeek') != 0) {
              throw Exception('Invalid route: ${splitRoute[0]}');
            }

            DateTime date = DateTime.parse(settings.name!.split('/').last);

            var mondayOfWeek = date.subtract(Duration(days: date.weekday - 1));

            WidgetBuilder builder;

            builder = (BuildContext context) => StudentWeekPage(
                  mondayOfWeek: mondayOfWeek,
                  storage: StudentWeekDataStorage(date: mondayOfWeek),
                );

            return CupertinoPageRoute(builder: builder, settings: settings);
          },
        ));
  }
}
