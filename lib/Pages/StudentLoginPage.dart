import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app/Models/Student.dart';
import 'package:hansenberg_app/Models/StudentNotifier.dart';
import 'package:hansenberg_app/Utilities/Clients/StudentClient.dart';
import 'package:hansenberg_app/Utilities/TokenStorage.dart';
import 'package:hansenberg_app/Widgets/ActivityIndicatorWithTitle.dart';
import 'package:provider/provider.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({Key? key, required this.studentClient, required this.tokenStorage}) : super(key: key);
  
  final StudentClient studentClient;
  final TokenStorage tokenStorage;

  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {

  Future<Student> _fetchStudent() async {
    final token = await widget.tokenStorage.readToken();

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

    return CupertinoPageScaffold(
      child: FutureBuilder<Student>(
        builder: (BuildContext futureContext, AsyncSnapshot<Student> snapshot) {
          if (snapshot.hasData) {
            Future.delayed(Duration.zero, () {
              Student student = snapshot.data!;

              if (student.studentName.isNotEmpty) {
                context.read<StudentNotifier>().set(student);
                Navigator.of(context).pushReplacementNamed('/student');
              }
              else {
                Navigator.of(context).pushReplacementNamed('/');
              }
            });

            return const ActivityIndicatorWithTitle();
          }
          else if (snapshot.hasError) {
            return Center(child: Text("${widget.runtimeType}: ${snapshot.error}"),);
          }
          else {
            return const ActivityIndicatorWithTitle();
          }
        },
        future: _fetchStudent(),
      ),
    );
  }
}
