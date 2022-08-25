import 'package:flutter/cupertino.dart';
import 'package:tilmeldings_system/Pages/StaffWeekPage.dart';
import 'package:tilmeldings_system/Utilities/Clients/EnlistmentClient.dart';
import 'package:tilmeldings_system/Utilities/Clients/HttpClient.dart';
import 'package:tilmeldings_system/Utilities/Clients/MenuClient.dart';
import 'package:tilmeldings_system/Utilities/util.dart';
import 'package:week_of_year/date_week_extensions.dart';

import 'StudentWeekPage.dart';

class WeekPage extends StatelessWidget {
  const WeekPage({
    Key? key,
    required this.httpClient,
    required this.userType
  }) : super(key: key);

  final HttpClient httpClient;
  final UserTypes userType;

  String initialRoute() {
    DateTime now = DateTime.now();
    return "${now.weekOfYear}";
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final week = int.parse(settings.name!);

    final now = DateTime.now();

    final difference = 7 * (week - now.weekOfYear);

    final next = now.add(Duration(days: difference));

    final mondayOfWeek = next.subtract(Duration(days: next.weekday - 1));

    WidgetBuilder builder;

    if (userType == UserTypes.student) {
      builder = (BuildContext context) => StudentWeekPage(
        mondayOfWeek: mondayOfWeek,
        menuClient: MenuClient(httpClient: httpClient),
        enlistmentClient: EnlistmentClient(httpClient: httpClient),
      );
    }
    else if (userType == UserTypes.student) {
      builder = (BuildContext context) => StaffWeekPage(
        mondayOfWeek: mondayOfWeek,
        menuClient: MenuClient(httpClient: httpClient),
        enlistmentClient: EnlistmentClient(httpClient: httpClient),
      );
    }
    else {
      throw Exception("Invalid user type");
    }

    return PageRouteBuilder(pageBuilder: (BuildContext context, _, __) => builder(context));
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
