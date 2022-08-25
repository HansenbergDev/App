import 'package:flutter/cupertino.dart';
import 'package:tilmeldings_system/Utilities/Clients/EnlistmentClient.dart';
import 'package:tilmeldings_system/Utilities/Clients/MenuClient.dart';

class StaffWeekPage extends StatefulWidget {
  const StaffWeekPage({
    Key? key,
    required this.mondayOfWeek,
    required this.menuClient,
    required this.enlistmentClient
  }) : super(key: key);

  final DateTime mondayOfWeek;
  final MenuClient menuClient;
  final EnlistmentClient enlistmentClient;

  @override
  State<StaffWeekPage> createState() => _StaffWeekPageState();
}

class _StaffWeekPageState extends State<StaffWeekPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
