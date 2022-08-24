import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tilmeldings_system/Models/Student.dart';
import 'package:tilmeldings_system/Models/StudentNotifier.dart';
import 'package:tilmeldings_system/Models/TokenNotifier.dart';
import 'package:tilmeldings_system/Utilities/Clients/StudentClient.dart';
import 'package:tilmeldings_system/Widgets/ActivityIndicatorWithTitle.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({Key? key, required this.studentClient}) : super(key: key);
  
  final StudentClient studentClient;

  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {

  Future<Student> _fetchStudent(String token) async {
    Student? student = await widget.studentClient.getStudent(token);

    if (student != null) {
      return student;
    }
    else {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(0);
      return Student(studentName: "", enrolledFrom: date, enrolledTo: date);
    }
  }
  
  @override
  Widget build(BuildContext context) {

    String token = context.select<TokenNotifier, String>((notifier) => notifier.token!);

    return CupertinoPageScaffold(
      child: FutureBuilder<Student>(
        builder: (BuildContext futureContext, AsyncSnapshot<Student> snapshot) {
          if (snapshot.hasData) {
            Future.delayed(Duration.zero, () {
              Student student = snapshot.data!;

              if (student.studentName.isNotEmpty) {
                context.read<StudentNotifier>().set(snapshot.data!);
                Navigator.of(context).pushReplacementNamed('/student');
              }
              else {
                Navigator.of(context).pushReplacementNamed('/');
              }
            });

            return const ActivityIndicatorWithTitle();
          }
          else if (snapshot.hasError) {
            return Center(child: Text("An error happened: ${snapshot.error}"),);
          }
          else {
            return const ActivityIndicatorWithTitle();
          }
        },
        future: _fetchStudent(token),
      ),
    );
  }
}
