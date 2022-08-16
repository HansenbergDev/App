import 'package:flutter/cupertino.dart';
import 'package:week_of_year/date_week_extensions.dart';
import 'MenuTile.dart';

class WeekPage extends StatefulWidget {
  const WeekPage({Key? key, required this.mondayOfWeek}) : super(key: key);

  final DateTime mondayOfWeek;

  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  String _dayNumberInWeekToDayString(int dayNumber) {
    switch (dayNumber) {
      case 1:
        return "Mandag";
      case 2:
        return "Tirsdag";
      case 3:
        return "Onsdag";
      case 4:
        return "Torsdag";
      case 5:
        return "Fredag";
      case 6:
        return "Lørdag";
      case 7:
        return "Søndag";
    }
    return "";
  }

  String _monthNumberToMonthString(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return "januar";
      case 2:
        return "februar";
      case 3:
        return "marts";
      case 4:
        return "april";
      case 5:
        return "maj";
      case 6:
        return "juni";
      case 7:
        return "juli";
      case 8:
        return "august";
      case 9:
        return "september";
      case 10:
        return "oktober";
      case 11:
        return "november";
      case 12:
        return "december";
    }

    return "";
  }

  void enlist(list, index) {
    list[index] = EnlistStates.enlisted;
  }

  void reject(list, index) {
    list[index] = EnlistStates.rejected;
  }

  var states = List<EnlistStates>.generate(5, (index) => EnlistStates.none);
  var menu = List<String>.generate(
      4,
          (index) =>
      "$index Lorem ipsum dolor sit amet, consectetur adipiscing elit.");

  @override
  Widget build(BuildContext context) {
    var dates = List<DateTime>.generate(
        5, (index) => widget.mondayOfWeek.add(Duration(days: index)));

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          onPressed: () => print("Back"),
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.arrow_left_circle_fill),
        ),
        middle: Text("Uge ${widget.mondayOfWeek.weekOfYear}"),
        trailing: CupertinoButton(
            onPressed: () => print("Forward"),
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.arrow_right_circle_fill)),
      ),
      child: CupertinoScrollbar(
          thumbVisibility: true,
          thickness: 6.0,
          thicknessWhileDragging: 10.0,
          radius: const Radius.circular(34.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return MenuTile(
                        dateString:
                        "${_dayNumberInWeekToDayString(dates[index].weekday)} d. ${dates[index].day} ${_monthNumberToMonthString(dates[index].month)}",
                        menuText: menu[index],
                        enlistForDinner: () => enlist(states, index),
                        rejectDinner: () => reject(states, index));
                  }),
            ),
          )),
    );
  }
}

/*

const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 70),
                    child: ColoredButton.filled(
                        onPressed: () => print("Sender tilmelding"),
                        fillColor: CupertinoColors.systemBlue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(CupertinoIcons.paperplane),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Send tilmelding"),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  )

 */

/*

child: ListView(
                children: <Widget>[
                  MenuTile(
                      dateString:
                      "${_dayNumberInWeekToDayString(dates[0].weekday)} d. ${dates[0].day} ${_monthNumberToMonthString(dates[0].month)}",
                      menuText: menu[0],
                      enlistForDinner: () => enlist(states[0]),
                      rejectDinner: () => reject(states[0])
                  ),
                  MenuTile(
                      dateString:
                      "${_dayNumberInWeekToDayString(tuesday.weekday)} d. ${tuesday.day} ${_monthNumberToMonthString(tuesday.month)}",
                      menuText: "Hotwings m/ kartofler & aioli",
                      enlistForDinner: () => print("I want dinner!"),
                      rejectDinner: () => print("I don't want dinner!")
                  ),
                  MenuTile(
                      dateString:
                      "${_dayNumberInWeekToDayString(wednesday.weekday)} d. ${wednesday.day} ${_monthNumberToMonthString(wednesday.month)}",
                      menuText: "Hotwings m/ kartofler & aioli",
                      enlistForDinner: () => print("I want dinner!"),
                      rejectDinner: () => print("I don't want dinner!")
                  ),
                  MenuTile(
                      dateString:
                      "${_dayNumberInWeekToDayString(thursday.weekday)} d. ${thursday.day} ${_monthNumberToMonthString(thursday.month)}",
                      menuText: "Hotwings m/ kartofler & aioli",
                      enlistForDinner: () => print("I want dinner!"),
                      rejectDinner: () => print("I don't want dinner!")
                  ),
                  // TODO: Fredag

                ],
              ),
 */
