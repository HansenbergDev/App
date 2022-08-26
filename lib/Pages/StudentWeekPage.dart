import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansenberg_app/Models/Enlistment.dart';
import 'package:hansenberg_app/Models/Menu.dart';
import 'package:hansenberg_app/Utilities/Clients/EnlistmentClient.dart';
import 'package:hansenberg_app/Utilities/Clients/MenuClient.dart';
import 'package:hansenberg_app/Utilities/TokenStorage.dart';
import 'package:hansenberg_app/Utilities/util.dart';
import 'package:hansenberg_app/Widgets/ActivityIndicatorWithTitle.dart';
import 'package:hansenberg_app/Widgets/IconCupertinoButton.dart';
import 'package:hansenberg_app/Widgets/TopNotification.dart';
import 'package:week_of_year/date_week_extensions.dart';

import '../Widgets/MenuTile.dart';

class StudentWeekPage extends StatefulWidget {
  const StudentWeekPage({
    Key? key,
    required this.mondayOfWeek,
    required this.menuClient,
    required this.enlistmentClient,
    required this.tokenStorage
  }) : super(key: key);

  final DateTime mondayOfWeek;
  final MenuClient menuClient;
  final EnlistmentClient enlistmentClient;
  final TokenStorage tokenStorage;

  @override
  State<StudentWeekPage> createState() => _StudentWeekPageState();
}

class _StudentWeekPageState extends State<StudentWeekPage> {

  Menu _menu = const Menu(monday: "", tuesday: "", wednesday: "", thursday: "");
  List<bool?> _enlistment = [];
  Enlistment _originalEnlistment = Enlistment.fromNullableBoolList(List<bool>.generate(5, (index) => false));
  bool _expanded = false;
  bool _enlistmentSent = false;

  Future<bool> _fetchData() async {
    Menu? menu;
    Enlistment? enlistment;

    menu = await widget.menuClient
        .getMenu(widget.mondayOfWeek.year, widget.mondayOfWeek.weekOfYear);

    if (menu != null) {
      _menu = menu;
      enlistment = await widget.enlistmentClient
          .getEnlistment(
          widget.mondayOfWeek.year, 
          widget.mondayOfWeek.weekOfYear, 
          await widget.tokenStorage.readToken()
      );

      if (enlistment != null) {
        _enlistmentSent = true;
        _enlistment = enlistment.toList();
        _originalEnlistment = enlistment;
      }
      else {
        _enlistment = List<bool?>.generate(5, (index) => index < 4 ? null : false);
      }
    }

    return true;
  }

  void _pushEnlistment(Function enlistmentPush) async {
    final year = widget.mondayOfWeek.year;
    final week = widget.mondayOfWeek.weekOfYear;
    final enlistment = Enlistment.fromNullableBoolList(_enlistment);
    final token = await widget.tokenStorage.readToken();
    
    bool status = await enlistmentPush(year, week, enlistment, token);

    showNotification(
        context: context,
        text: status ? "Tak for din tilmelding!" : "Der skete en fejl",
        backgroundColor: status ? CupertinoColors.systemGreen : CupertinoColors.destructiveRed,
        textColor: CupertinoColors.white,
        duration: const Duration(seconds: 2)
    );
  }

  Future<bool> _sendData(int year, int week, Enlistment enlistment, String token) async {
    bool status = await widget.enlistmentClient.createEnlistment(year, week, enlistment, token);
    
    if (status) {
      setState(() {
        _enlistmentSent = true;
        _originalEnlistment = Enlistment.fromNullableBoolList(_enlistment);
      });
    }
    
    return status;
  }

  Future<bool> _updateData(int year, int week, Enlistment enlistment, String token) async {
    bool status = await widget.enlistmentClient.updateEnlistment(year, week, enlistment, token);
    
    if (status) {
      setState(() {
        _originalEnlistment = Enlistment.fromNullableBoolList(_enlistment);
      });
    }
    
    return status;
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

  void _makeEnlistmentChoice(int index, bool choice) async {
    setState(() {
      _enlistment[index] = choice;
    });
  }

  bool get _enlistmentIsValid {
    return _enlistment
        .take(4)
        .any((element) => element == null)
        ? false : true;
  }

  bool get _unsavedChanges {
    return !const ListEquality().equals(_originalEnlistment.toList(), _enlistment);
  }

  bool get _canNavigate {
    return (!_unsavedChanges || _menu.any((element) => element.isEmpty));
  }

  void Function()? _enlistButtonPress() {
    if (!_menu.any((element) => element.isEmpty)) {
      if (_enlistmentSent) {
        if (_unsavedChanges) {
          return () => _pushEnlistment(_updateData);
        }
      }
      else if (_enlistmentIsValid){
        return () => _pushEnlistment(_sendData);
      }
    }

    return null;
  }

  Widget _scrollDetector(Widget child) {

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (_canNavigate) {
          if (details.primaryVelocity! > 0) {
            _navigateToPreviousWeek();
          }
          else if (details.primaryVelocity! < 0){
            _navigateToNextWeek();
          }
        }
        else {
          showNotification(
              context: context,
              text: "Du mangler at sende din tilmelding!",
              backgroundColor: CupertinoColors.destructiveRed,
              textColor: CupertinoColors.white,
              duration: const Duration(seconds: 5)
          );
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var dates = List<DateTime>.generate(
        5, (index) => widget.mondayOfWeek.add(Duration(days: index)));

    return FutureBuilder<bool>(
        builder: (BuildContext futureContext, AsyncSnapshot<bool> snapshot) {
          Widget child;

          if (snapshot.hasData) {

            if (_menu.monday.isEmpty ||
                _menu.tuesday.isEmpty ||
                _menu.wednesday.isEmpty ||
                _menu.thursday.isEmpty) {
              child = const Material(
                child: Center(
                  child: Text(
                    "Ingen menu tilgængelig for denne uge",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              );
            }
            else {
              child = Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: ListView.builder(
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        switch (index) {
                          case 0:
                          case 1:
                          case 2:
                          case 3:
                            return MenuTile(
                              dateString:
                              "${dayNumberInWeekToDayString(dates[index].weekday)} d. ${dates[index].day} ${monthNumberToMonthString(dates[index].month)}",
                              menuText: _menu.toList()[index],
                              enlistmentState: _enlistment[index],
                              enlistForDinner: () => _makeEnlistmentChoice(index, true),
                              rejectDinner: () => _makeEnlistmentChoice(index, false),
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
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                                enlistmentState: _enlistment[index],
                                enlistForDinner: () => _makeEnlistmentChoice(index, true),
                                rejectDinner: () => _makeEnlistmentChoice(index, false),
                              );
                            }
                          case 5:
                            return const SizedBox(
                              height: 70,
                            );
                          default:
                            return const Text("This should not show up");
                        }
                      },
                    )),
              );
              // child = CupertinoScrollbar(
              //     thumbVisibility: true,
              //     thickness: 6.0,
              //     thicknessWhileDragging: 10.0,
              //     radius: const Radius.circular(34.0),
              //     child: );
            }
          }
          else if (snapshot.hasError) {
            child = _scrollDetector(Center(child: Text("${snapshot.error}")));
          }
          else {
            child = _scrollDetector(const ActivityIndicatorWithTitle());
          }

          return Scaffold(
            floatingActionButtonAnimator: null,
            floatingActionButton: IconCupertinoButtonFilled(
                onPressed: _enlistButtonPress(),
                text: "Send tilmelding",
                icon: CupertinoIcons.paperplane,
                // text: _enlistmentSent ? "Opdater tilmelding" : "Send tilmelding",
                // icon: _enlistmentSent ? CupertinoIcons.refresh : CupertinoIcons.paperplane
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            body: CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  leading: CupertinoButton(
                    onPressed: _canNavigate ? () => _navigateToPreviousWeek() : null,
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.arrow_left_circle_fill, size: 30,),
                  ),
                  middle: Text("Uge ${widget.mondayOfWeek.weekOfYear}"),
                  trailing: CupertinoButton(
                      onPressed: _canNavigate ? () => _navigateToNextWeek() : null,
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.arrow_right_circle_fill, size: 30,)),
                ),
                child: _scrollDetector(child)
            ),
          );
        },
      future: _menu.any((element) => element.isEmpty) ? _fetchData() : null,
    );
  }
}
