import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansenberg_app/Models/Menu.dart';
import 'package:hansenberg_app/Models/StaffEnlistmentWeekData.dart';
import 'package:hansenberg_app/Utilities/Clients/StaffEnlistmentClient.dart';
import 'package:hansenberg_app/Utilities/Clients/MenuClient.dart';
import 'package:hansenberg_app/Utilities/util.dart';
import 'package:hansenberg_app/Widgets/IconCupertinoButton.dart';
import 'package:hansenberg_app/Widgets/StaffTile.dart';
import 'package:week_of_year/date_week_extensions.dart';

class StaffWeekPage extends StatefulWidget {
  const StaffWeekPage({
    Key? key,
    required this.mondayOfWeek,
    required this.menuClient,
    required this.enlistmentClient
  }) : super(key: key);

  final DateTime mondayOfWeek;
  final MenuClient menuClient;
  final StaffEnlistmentClient enlistmentClient;

  @override
  State<StaffWeekPage> createState() => _StaffWeekPageState();
}

class _StaffWeekPageState extends State<StaffWeekPage> {

  List<int> _enlistments = [];
  bool _showCreateMenuButton = false;

  Future<bool> _fetchData(String token) async {
    StaffEnlistmentWeekData? weekData;

    if (await widget.menuClient.getMenu(widget.mondayOfWeek.year, widget.mondayOfWeek.weekOfYear) != null) {
      weekData = await widget.enlistmentClient
          .getEnlistments(widget.mondayOfWeek.year, widget.mondayOfWeek.weekOfYear, token);

      if (weekData != null) {
        _enlistments = weekData.toList();
        return true;
      }
    }

    return false;
  }

  void _navigateToNextWeek() {
    int week = widget.mondayOfWeek.weekOfYear + 1;
    _navigateToWeek(week);
  }

  void _navigateToPreviousWeek() {
    int week = widget.mondayOfWeek.weekOfYear - 1;
    _navigateToWeek(week);
  }

  void _navigateToWeek(int week) {
    Navigator.of(context).pushReplacementNamed('$week');
  }

  Widget _scrollDetector(Widget child) {
    return GestureDetector(
      onHorizontalDragEnd: (details) => {
        if (details.primaryVelocity! > 0) {
          _navigateToPreviousWeek()
        }
        else if (details.primaryVelocity! < 0){
          _navigateToNextWeek()
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {

    var dates = List<DateTime>.generate(
        5, (index) => widget.mondayOfWeek.add(Duration(days: index)));

    Widget child = Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            switch(index) {
              case 0:
                return StaffTile(
                    title: "Indskrevne",
                    text: 'Antal',
                    button: makeSquareButton(
                        () { },
                        CupertinoIcons.pencil,
                        CupertinoColors.white,
                        CupertinoColors.systemBlue
                    )
                );
              case 1:
                return const StaffTile(title: "Registrerede", text: 'Antal', button: null);
              case 2:case 3:case 4:case 5:
                return StaffTile(
                    title: "${dayNumberInWeekToDayString(dates[index - 2].weekday)} d. ${dates[index - 2].day} ${monthNumberToMonthString(dates[index - 2].month)}",
                    text: 'Antal',
                    button: makeSquareButton(
                            () { },
                        CupertinoIcons.info,
                        CupertinoColors.white,
                        CupertinoColors.systemBlue
                    )
                );
              default:
                return const Text("This should not show up");
            }

          }
        )
      ),
    );

    return Scaffold(
      floatingActionButtonAnimator: null,
      floatingActionButton: const IconCupertinoButtonFilled(
          onPressed: null,
          text: "Rediger menu",
          icon: CupertinoIcons.paperplane),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: CupertinoButton(
              onPressed: () => _navigateToPreviousWeek(),
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.arrow_left_circle_fill, size: 30,),
            ),
            middle: Text("Uge ${widget.mondayOfWeek.weekOfYear}"),
            trailing: CupertinoButton(
                onPressed: () => _navigateToNextWeek(),
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.arrow_right_circle_fill, size: 30,)),
          ),
          child: _scrollDetector(child)
      ),
    );
  }
}
