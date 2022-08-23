import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tilmeldings_system/Models/Student.dart';
import 'package:tilmeldings_system/Models/TokenNotifier.dart';
import 'package:tilmeldings_system/Utilities/Clients/StudentClient.dart';
import 'package:tilmeldings_system/Utilities/Storage/TokenStorage.dart';
import 'package:tilmeldings_system/Widgets/DatePicker.dart';
import 'package:tilmeldings_system/Widgets/ItemPicker.dart';
import 'package:tilmeldings_system/Widgets/TextfieldWithTitle.dart';

import '../Models/StudentNotifier.dart';
import '../Widgets/IconCupertinoButton.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({Key? key, required this.studentClient, required this.storage}) : super(key: key);

  final StudentClient studentClient;
  final TokenStorage storage;

  @override
  State<StudentRegistration> createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  final List<String> _educations = [
    "Beslagsmed",
    "Frisør",
    "Multimediedesigner",
    "Dyrepasser"
  ];

  final List<String> _course = ["GF1", "GF2", "HF"];

  late TextEditingController _nameController;
  int _selectedEducation = 0;
  int _selectedCourse = 0;
  DateTime _enrolledFrom = DateTime.now();
  DateTime _enrolledTo = DateTime.now();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  void _sendRegistration() async {
    String token;

    // TODO: Input validation

    try {
      token = await widget.studentClient.registerStudent(_nameController.text, _enrolledFrom, _enrolledTo);
      Future.delayed(Duration.zero, () {
        context.read<TokenNotifier>().setToken(token.split('/').last);
        context.read<StudentNotifier>().set(
            Student(
                studentName: _nameController.text,
                enrolledFrom: _enrolledFrom,
                enrolledTo: _enrolledTo
            )
        );

        Navigator.of(context).pushReplacementNamed("/student");
      });
    }
    catch(e) {
      // TODO: Vis popup
      throw Exception(e);
    }

    try {
      await widget.storage.writeToken(token);
    }
    catch(e) {
      // TODO: Gør noget?
      throw Exception(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    _educations.sort((a, b) => a.compareTo(b));

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          border: null,
          backgroundColor: CupertinoColors.systemBackground,
          leading: CupertinoButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.arrow_left,
            ),
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Elev",
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextfieldWithTitle(
                  title: "Fornavn",
                  placeholder: "Skriv dit fornavn",
                  controller: _nameController,
                ),
                ItemPicker(
                    text: "Vælg din klasse: ",
                    fontSize: 18,
                    list: _educations,
                    callback: (int selected) => _selectedEducation = selected
                ),
                ItemPicker(
                    text: "Vælg forløb: ",
                    fontSize: 18,
                    list: _course,
                    callback: (int selected) => _selectedCourse = selected
                ),
                DatePicker(
                    title: "Indskrevet fra",
                    fontSize: 18,
                    callback: (DateTime date) => _enrolledFrom = date
                ),
                DatePicker(
                    title: "Indskrevet til",
                    fontSize: 18,
                    callback: (DateTime date) => _enrolledTo = date
                ),
                const SizedBox(height: 20,),
                // https://api.flutter.dev/flutter/cupertino/CupertinoDatePicker-class.html
                IconCupertinoButtonFilled(
                  onPressed: () => _sendRegistration(),
                  text: "Log ind",
                  icon: CupertinoIcons.chevron_right_square,
                ),
              ],
            ),
          ),
        ));
  }
}
