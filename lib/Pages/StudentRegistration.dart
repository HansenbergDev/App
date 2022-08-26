import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app/Models/Student.dart';
import 'package:hansenberg_app/Utilities/Clients/StudentClient.dart';
import 'package:hansenberg_app/Utilities/TokenStorage.dart';
import 'package:hansenberg_app/Utilities/util.dart';
import 'package:hansenberg_app/Widgets/DatePicker.dart';
import 'package:hansenberg_app/Widgets/TextfieldWithTitle.dart';
import 'package:provider/provider.dart';

import '../Models/StudentNotifier.dart';
import '../Widgets/IconCupertinoButton.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({Key? key, required this.studentClient, required this.tokenStorage}) : super(key: key);

  final StudentClient studentClient;
  final TokenStorage tokenStorage;

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
    String token = "";

    // TODO: Input validation

    try {
      token = await widget.studentClient.registerStudent(_nameController.text, _enrolledFrom, _enrolledTo);
      await widget.tokenStorage.writeToken(token);

      Future.delayed(Duration.zero, () {
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
      // throw Exception(e);

      showNotification(
          context: context,
          text: "Ingen forbindelse",
          backgroundColor: CupertinoColors.destructiveRed,
          textColor: CupertinoColors.white,
          duration: const Duration(seconds: 3)
      );
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
            onPressed: () => Navigator.pop(context),
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
                // ItemPicker(
                //     text: "Vælg din klasse: ",
                //     fontSize: 18,
                //     list: _educations,
                //     callback: (int selected) => _selectedEducation = selected
                // ),
                // ItemPicker(
                //     text: "Vælg forløb: ",
                //     fontSize: 18,
                //     list: _course,
                //     callback: (int selected) => _selectedCourse = selected
                // ),
                const SizedBox(
                  height: 10,
                ),
                DatePicker(
                    title: "Indskrevet fra",
                    fontSize: 18,
                    callback: (DateTime date) => _enrolledFrom = date
                ),
                const SizedBox(
                  height: 20,
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
                  text: "Registrér",
                  icon: CupertinoIcons.chevron_right_square,
                ),
              ],
            ),
          ),
        ));
  }
}
