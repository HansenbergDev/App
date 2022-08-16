import 'package:flutter/cupertino.dart';
import 'package:week_of_year/date_week_extensions.dart';
import 'WeekPage.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
        child: Navigator(
          // TODO: Der skal muligvis bruges en FutureBuilder her i stedet, så filer kan loades
          // https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
          initialRoute: 'mondayOfWeek/${DateTime.now()}',
          onGenerateRoute: (RouteSettings settings) {

            var splitRoute = settings.name.toString().split('/');

            if (splitRoute[0].compareTo('mondayOfWeek') != 0) {
              throw Exception('Invalid route: ${splitRoute[0]}');
            }

            DateTime date = DateTime.parse(settings.name.toString().split('/')[1]);

            var mondayOfWeek = date.subtract(Duration(days: date.weekday - 1));

            WidgetBuilder builder;

            builder = (BuildContext context) => WeekPage(
                mondayOfWeek: mondayOfWeek,
                menu: List<String>.generate(4, (index) => "$index This is a menu."));

            return CupertinoPageRoute(builder: builder, settings: settings);
          },
        )
    );
  }
}
