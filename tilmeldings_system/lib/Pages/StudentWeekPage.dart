import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tilmeldings_system/Utilities/util.dart';
import 'package:tilmeldings_system/Widgets/IconCupertinoButton.dart';
import 'package:week_of_year/date_week_extensions.dart';

import '../Models/StudentWeekData.dart';
import '../Utilities/Storage/StudentWeekDataStorage.dart';
import '../Widgets/MenuTile.dart';

class StudentWeekPage extends StatefulWidget {
  const StudentWeekPage(
      {Key? key, required this.mondayOfWeek, required this.storage})
      : super(key: key);

  final DateTime mondayOfWeek;
  final StudentWeekDataStorage storage;

  @override
  State<StudentWeekPage> createState() => _StudentWeekPageState();
}

class _StudentWeekPageState extends State<StudentWeekPage> {
  
  Future<void> _sendWeekData(StudentWeekData weekData) {
    // TODO: Implement send to server
    return Future.delayed(const Duration(seconds: 2));
  }

  Future<File> _saveWeekData(StudentWeekData weekData) {
    return widget.storage.writeWeekData(weekData);
  }

  void _makeEnlistmentChoice(int index, EnlistmentStates choice) {
    setState(() {
      _weekData.states[index] = choice;
      _saveWeekData(_weekData);
    });
  }

  void _navigateToNextWeek() {
    DateTime date = widget.mondayOfWeek.add(const Duration(days: 7));
    _navigateToWeek(date);
  }

  void _navigateToPreviousWeek() {
    DateTime date = widget.mondayOfWeek.subtract(const Duration(days: 7));
    _navigateToWeek(date);
  }

  void _navigateToWeek(DateTime date) {
    Navigator.of(context).pushReplacementNamed(
        "mondayOfWeek/${DateFormat("yyyy-MM-dd").format(date)}");
  }

  StudentWeekData _weekData = const StudentWeekData(menu: [], states: []);
  bool _expanded = false;

  // TODO: Implement this:
  // late Future<StudentWeekData> _weekData;

  // @override
  // void initState() {
  //   super.initState();
  //   _weekData = widget.storage.readWeekData();
  // }

  @override
  Widget build(BuildContext context) {
    var dates = List<DateTime>.generate(
        5, (index) => widget.mondayOfWeek.add(Duration(days: index)));

    return FutureBuilder<StudentWeekData>(
        builder:
            (BuildContext context, AsyncSnapshot<StudentWeekData> snapshot) {
          Widget child;

          if (snapshot.hasData) {
            if (_weekData.states.isEmpty) {
              _weekData = snapshot.data!;
            }

            child = CupertinoScrollbar(
                thumbVisibility: true,
                thickness: 6.0,
                thicknessWhileDragging: 10.0,
                radius: const Radius.circular(34.0),
                child: Center(
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: ListView.builder(
                        itemCount: 8,
                        itemBuilder: (BuildContext context, int index) {
                          switch (index) {
                            case 0:
                            case 1:
                            case 2:
                            case 3:
                              return MenuTile(
                                dateString:
                                    "${dayNumberInWeekToDayString(dates[index].weekday)} d. ${dates[index].day} ${monthNumberToMonthString(dates[index].month)}",
                                menuText: _weekData.menu[index],
                                enlistmentState: _weekData.states[index],
                                enlistForDinner: () => _makeEnlistmentChoice(index, EnlistmentStates.enlisted),
                                rejectDinner: () => _makeEnlistmentChoice(index, EnlistmentStates.rejected),
                              );
                            case 4:
                              if (!_expanded) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: const BoxDecoration(
                                      color: CupertinoColors.systemBackground,
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      _expanded = true;
                                    }),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: const [
                                        Text(
                                          // TODO: Bedre titel på denne
                                          "Fredag (Frivilligt)",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          CupertinoIcons.chevron_down,
                                          color: CupertinoColors.black,
                                          size: 30,
                                        )
                                      ],
                                    )
                                  ),
                                );
                              }
                              else {
                                return MenuTile(
                                  dateString:
                                  "${dayNumberInWeekToDayString(dates[index].weekday)} d. ${dates[index].day} ${monthNumberToMonthString(dates[index].month)}",
                                  menuText: "Der er ikke en menu for fredag, da dette er et særtilbud",
                                  enlistmentState: _weekData.states[index],
                                  enlistForDinner: () => _makeEnlistmentChoice(index, EnlistmentStates.enlisted),
                                  rejectDinner: () => _makeEnlistmentChoice(index, EnlistmentStates.rejected),
                                );
                              }
                            case 5:
                              return const SizedBox(
                                height: 20,
                              );
                            case 6:
                              return IconCupertinoButtonFilled(
                                  onPressed: () => _weekData.states
                                      .take(4)
                                      .any((element) => element == EnlistmentStates.none)
                                      ? null : () => _sendWeekData(_weekData),
                                  text: "Send tilmelding",
                                  icon: CupertinoIcons.paperplane);
                            case 7:
                              return const SizedBox(
                                height: 30,
                              );
                            default:
                              return const Text("This should not show up");
                          }
                        },
                      )),
                ));
          } else if (snapshot.hasError) {
            child = const Center(
              child: Text("Ingen menu tilgængelig for denne uge"),
            );
          } else {
            child = const CupertinoActivityIndicator();
          }

          return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                leading: CupertinoButton(
                  onPressed: () => _navigateToPreviousWeek(),
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.arrow_left_circle_fill),
                ),
                middle: Text("Uge ${widget.mondayOfWeek.weekOfYear}"),
                trailing: CupertinoButton(
                    onPressed: () => _navigateToNextWeek(),
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.arrow_right_circle_fill)),
              ),
              child: GestureDetector(
                // TODO: Check om det her gør som forventet (på en telefon...)
                onHorizontalDragEnd: (details) => {
                  if (details.primaryVelocity! > 0) {
                    _navigateToPreviousWeek()
                  }
                  else if (details.primaryVelocity! < 0){
                    _navigateToNextWeek()
                  }
                },
                child: child,
              ));
        },
        future:
            _weekData.states.isEmpty ? widget.storage.readWeekData() : null);
  }
}
