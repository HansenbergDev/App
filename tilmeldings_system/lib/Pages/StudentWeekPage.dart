import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tilmeldings_system/Models/Enlistment.dart';
import 'package:tilmeldings_system/Models/Menu.dart';
import 'package:tilmeldings_system/Models/TokenNotifier.dart';
import 'package:tilmeldings_system/Utilities/Clients/StudentEnlistmentClient.dart';
import 'package:tilmeldings_system/Utilities/Clients/MenuClient.dart';
import 'package:tilmeldings_system/Utilities/util.dart';
import 'package:tilmeldings_system/Widgets/ActivityIndicatorWithTitle.dart';
import 'package:tilmeldings_system/Widgets/IconCupertinoButton.dart';
import 'package:week_of_year/date_week_extensions.dart';

import '../Widgets/MenuTile.dart';

class StudentWeekPage extends StatefulWidget {
  const StudentWeekPage({
    Key? key,
    required this.mondayOfWeek,
    required this.menuClient,
    required this.enlistmentClient
  }) : super(key: key);

  final DateTime mondayOfWeek;
  final MenuClient menuClient;
  final StudentEnlistmentClient enlistmentClient;

  @override
  State<StudentWeekPage> createState() => _StudentWeekPageState();
}

class _StudentWeekPageState extends State<StudentWeekPage> {

  Menu _menu = const Menu(monday: "", tuesday: "", wednesday: "", thursday: "");
  List<EnlistmentStates> _enlistments = [];
  List<EnlistmentStates> _originalEnlistments = [];
  bool _expanded = false;
  bool _enlistmentSent = false;

  Future<Enlistment?> _getEnlistment(String token) {
    return widget.enlistmentClient.getEnlistment(
        widget.mondayOfWeek.year,
        widget.mondayOfWeek.weekOfYear,
        token);
  }

  Future<void> _sendEnlistment(Enlistment enlistment, String token) {
    return widget.enlistmentClient.createEnlistment(
        widget.mondayOfWeek.year,
        widget.mondayOfWeek.weekOfYear,
        enlistment,
        token
    );
  }

  Future<void> _updateEnlistment(Enlistment enlistment, String token) {
    return widget.enlistmentClient.updateEnlistment(
      widget.mondayOfWeek.year,
      widget.mondayOfWeek.weekOfYear,
      enlistment,
      token
    );
  }

  Future<Menu?> _getMenu() {
    return widget.menuClient.getMenu(
        widget.mondayOfWeek.year,
        widget.mondayOfWeek.weekOfYear
    );
  }

  Future<bool> _fetchData(String token) async {
    Menu? menu;
    Enlistment? enlistment;

    menu = await _getMenu();

    if (menu != null) {
      _menu = menu;
      enlistment = await _getEnlistment(token);

      if (enlistment != null) {
        _enlistmentSent = true;
        _enlistments = enlistment
            .map((e) => e ? EnlistmentStates.enlisted : EnlistmentStates.rejected)
            .toList();
        _originalEnlistments = [..._enlistments];
      }
      else {
        _enlistments = List<EnlistmentStates>.generate(5, (index) => index < 4 ? EnlistmentStates.none : EnlistmentStates.rejected);
      }
    }

    return true;
  }

  void _sendData(String token) async {
    setState(() {
      _enlistmentSent = true;
      _originalEnlistments = [..._enlistments];
    });
    return await _sendEnlistment(Enlistment.fromEnlistmentStates(_enlistments), token);
  }

  void _updateData(String token) async {
    setState(() {
      _originalEnlistments = [..._enlistments];
    });
    return await _updateEnlistment(Enlistment.fromEnlistmentStates(_enlistments), token);
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


  void _makeEnlistmentChoice(int index, EnlistmentStates choice) async {
    setState(() {
      _enlistments[index] = choice;
    });
  }

  bool get _enlistmentIsValid {
    return _enlistments
        .take(4)
        .any((element) => element == EnlistmentStates.none)
        ? false : true;
  }

  void Function()? _enlistButtonPress(String token) {
    if (!_menu.any((element) => element.isEmpty)) {
      if (_enlistmentSent) {
        if (!const ListEquality().equals(_originalEnlistments, _enlistments)) {
          return () => _updateData(token);
        }
      }
      else if (_enlistmentIsValid){
        return () => _sendData(token);
      }
    }

    return null;
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

    String token = context.select<TokenNotifier, String>((notifier) => notifier.token!);

    return FutureBuilder<bool>(
        builder: (BuildContext futureContext, AsyncSnapshot<bool> snapshot) {
          Widget child;

          if (snapshot.hasData) {

            if (_menu.monday.isEmpty ||
                _menu.tuesday.isEmpty ||
                _menu.wednesday.isEmpty ||
                _menu.thursday.isEmpty) {
              child = const Center(
                child: Text("Ingen menu tilgængelig for denne uge"),
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
                              enlistmentState: _enlistments[index],
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
                                enlistmentState: _enlistments[index],
                                enlistForDinner: () => _makeEnlistmentChoice(index, EnlistmentStates.enlisted),
                                rejectDinner: () => _makeEnlistmentChoice(index, EnlistmentStates.rejected),
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
            child = _scrollDetector(Center(child: Text("${widget.runtimeType}: ${snapshot.error}")));
          }
          else {
            child = _scrollDetector(const ActivityIndicatorWithTitle());
          }

          return Scaffold(
            floatingActionButtonAnimator: null,
            floatingActionButton: IconCupertinoButtonFilled(
                onPressed: _enlistButtonPress(token),
                text: _enlistmentSent ? "Opdater tilmelding" : "Send tilmelding",
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
        },
      future: _menu.any((element) => element.isEmpty) ? _fetchData(token) : null,
    );
  }
}
