import 'package:flutter/cupertino.dart';
import 'WeekPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.studentName}) : super(key: key);

  final String studentName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.secondarySystemBackground,
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            onPressed: () => print("Menu"),
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.bars),
          ),
          middle: Text("Hej ${widget.studentName}!"),
          trailing: CupertinoButton(
            onPressed: () => print("Chat"),
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.chat_bubble_text),
          ),
        ),
        child: WeekPage(mondayOfWeek: DateTime.utc(2022, 10, 31)));
  }
}