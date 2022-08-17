import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:week_of_year/date_week_extensions.dart';
import 'MenuTile.dart';
import '../Controllers/ColoredCupertinoButton.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class WeekData {
  const WeekData({required this.menu, required this.states});

  final List<EnlistStates> states;
  final List<String> menu;

  @override
  String toString() {
    String result = "";

    for (int i = 0; i < states.length; i++) {
      result = "$result${menu[i]}|${states[i]};";
    }

    return result;
  }
}

class WeekDataStorage {
  const WeekDataStorage({required this.date});

  final DateTime date;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    Directory("$path/week_data").exists().then((value) => !value ? Directory("$path/week_data").create() : "");

    return File('$path/week_data/${DateFormat("yyyy-MM-dd").format(date)}');
  }

  Future<WeekData> readWeekData() async {
    final file = await _localFile;
    final content = await file.readAsString();

    final days = content.split(';').take(5).toList();

    return WeekData(
        menu: days.map((day) => day.split('|')[0])
            .toList(),
        states: days.map((day) {
          var split = day.split('|')[1];

          var states = EnlistStates.values;
          var state = states.firstWhere((element) => "EnlistStates.${describeEnum(element)}".compareTo(split) == 0);
          return state;
        })
            .toList()
    );
  }

  Future<File> writeWeekData(WeekData data) async {
    final file = await _localFile;
    return file.writeAsString(data.toString());
  }
}

class WeekPage extends StatefulWidget {
  const WeekPage({Key? key, required this.mondayOfWeek, required this.storage}) : super(key: key);

  final DateTime mondayOfWeek;
  final WeekDataStorage storage;

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

  Future<void> sendWeekData(WeekData weekData) {
    // TODO: Implement send to server
    return Future.delayed(const Duration(seconds: 2));
  }

  Future<File> writeWeekData(WeekData weekData) {
    return widget.storage.writeWeekData(weekData);
  }

  late WeekData _weekData;

  @override
  Widget build(BuildContext context) {
    var dates = List<DateTime>.generate(
        5, (index) => widget.mondayOfWeek.add(Duration(days: index)));
    
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<WeekData> snapshot) {

        Widget child;

        if (snapshot.hasData) {
          _weekData = snapshot.data!;
          child = CupertinoScrollbar(
              thumbVisibility: true,
              thickness: 6.0,
              thicknessWhileDragging: 10.0,
              radius: const Radius.circular(34.0),
              child: Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: ListView(
                      children: [
                        MenuTile(
                            dateString:
                            "${_dayNumberInWeekToDayString(dates[0].weekday)} d. ${dates[0].day} ${_monthNumberToMonthString(dates[0].month)}",
                            menuText: _weekData.menu[0],
                            enlistmentState: _weekData.states[0],
                            enlistForDinner: () => setState(() {
                              _weekData.states[0] = EnlistStates.enlisted;
                              writeWeekData(_weekData);
                            }),
                            rejectDinner: () => setState(() {
                              _weekData.states[0] = EnlistStates.rejected;
                              writeWeekData(_weekData);
                            }),
                        ),
                        MenuTile(
                            dateString:
                            "${_dayNumberInWeekToDayString(dates[1].weekday)} d. ${dates[1].day} ${_monthNumberToMonthString(dates[1].month)}",
                            menuText: _weekData.menu[1],
                            enlistmentState: _weekData.states[1],
                          enlistForDinner: () => setState(() {
                            _weekData.states[1] = EnlistStates.enlisted;
                            writeWeekData(_weekData);
                          }),
                          rejectDinner: () => setState(() {
                            _weekData.states[1] = EnlistStates.rejected;
                            writeWeekData(_weekData);
                          }),
                        ),
                        MenuTile(
                            dateString:
                            "${_dayNumberInWeekToDayString(dates[2].weekday)} d. ${dates[2].day} ${_monthNumberToMonthString(dates[2].month)}",
                            menuText: _weekData.menu[2],
                            enlistmentState: _weekData.states[2],
                            enlistForDinner: () => setState(() {
                              _weekData.states[2] = EnlistStates.enlisted;
                              writeWeekData(_weekData);
                            }),
                            rejectDinner: () => setState(() {
                              _weekData.states[2] = EnlistStates.rejected;
                              writeWeekData(_weekData);
                            }),
                        ),
                        MenuTile(
                            dateString:
                            "${_dayNumberInWeekToDayString(dates[3].weekday)} d. ${dates[3].day} ${_monthNumberToMonthString(dates[3].month)}",
                            menuText: _weekData.menu[3],
                            enlistmentState: _weekData.states[3],
                            enlistForDinner: () => setState(() {
                              _weekData.states[3] = EnlistStates.enlisted;
                              writeWeekData(_weekData);
                            }),
                            rejectDinner: () => setState(() {
                              _weekData.states[3] = EnlistStates.rejected;
                              writeWeekData(_weekData);
                            }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // TODO: Fredag
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 60),
                          child: CupertinoButton.filled(
                            disabledColor: CupertinoColors.systemGrey,
                            onPressed: _weekData.states.take(4).any((element) => element == EnlistStates.none) ? null : () => sendWeekData(_weekData),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(CupertinoIcons.paperplane),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Send tilmelding"),
                              ],
                            )
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    )
                ),
              ));
        }
        else if (snapshot.hasError) {
          child = const Center(
            child: Text("Ingen menu tilgængelig for denne uge"),
          );
        }
        else {
          child = const CupertinoActivityIndicator();
        }

        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.secondarySystemBackground,
          navigationBar: CupertinoNavigationBar(
              leading: CupertinoButton(
                onPressed: () => {
                  Navigator
                      .of(context)
                      .pushReplacementNamed("mondayOfWeek/${DateFormat("yyyy-MM-dd").format(widget.mondayOfWeek.subtract(const Duration(days: 7)))}")
                },
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.arrow_left_circle_fill),
              ),
              middle: Text("Uge ${widget.mondayOfWeek.weekOfYear}"),
              trailing: CupertinoButton(
                  onPressed: () => {
                    Navigator
                        .of(context)
                        .pushReplacementNamed("mondayOfWeek/${DateFormat("yyyy-MM-dd").format(widget.mondayOfWeek.add(const Duration(days: 7)))}")
                  },
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.arrow_right_circle_fill)),
            ),
          child: child);
      },
      future: widget.storage.readWeekData(),
    );
  }
}