import 'package:flutter/cupertino.dart';
import 'package:tilmeldings_system/Pages/WeekPage.dart';

class StaffPage extends WeekPage {
  const StaffPage({
    Key? key,
    required super.httpClient,
    required super.userType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.secondarySystemBackground,
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            // TODO: Implement menu
            onPressed: () => print("Menu"),
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.bars),
          ),
          trailing: CupertinoButton(
            // TODO: Implement chat
            onPressed: () => print("Chat"),
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.chat_bubble_text),
          ),
        ),
        child: Navigator(
          initialRoute: initialRoute(),
          onGenerateRoute: (RouteSettings settings) => onGenerateRoute(settings),
        ));
  }
}
