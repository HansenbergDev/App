import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app_core/Widgets/IconCupertinoButton.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Velkommen!", style: TextStyle(fontSize: 40),),
              // const SizedBox(height: 20),
              // const Text("Vælg hvad du vil logge ind som:"),
              const SizedBox(height: 30,),
              IconCupertinoButtonFilled(
                  onPressed: () => Navigator.of(context).pushNamed("/student/registration"),
                  text: "Elev",
                  icon: CupertinoIcons.person
              ),
            ],
          ),
        ),
    )
    );
  }
}
