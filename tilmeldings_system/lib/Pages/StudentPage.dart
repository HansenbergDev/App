import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tilmeldings_system/Models/StudentNotifier.dart';
import 'package:tilmeldings_system/Pages/WeekPage.dart';

class StudentPage extends WeekPage {
  const StudentPage({
    Key? key,
    required super.httpClient,
    required super.userType,
  }) : super(key: key);

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
            child: const Icon(CupertinoIcons.bars, size: 30,),
          ),
          middle: Text("Hej $studentName!"),
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
        ));
  }
}
