import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app/Utilities/util.dart';
import 'package:hansenberg_app/Widgets/ColoredCupertinoButton.dart';

class IconCupertinoButtonFilled extends StatelessWidget {
  const IconCupertinoButtonFilled({Key? key, required this.onPressed, required this.text, required this.icon}) : super(key: key);

  final VoidCallback? onPressed;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60),
      child: ColoredButton.filled(
          customDisabledColor: CupertinoColors.systemGrey,
          onPressed: onPressed,
          fillColor: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(
                width: 10,
              ),
              Text(text,),
            ],
          )),
    );
  }
}

class IconCupertinoButton extends StatelessWidget {
  const IconCupertinoButton({Key? key, required this.onPressed, required this.text, required this.icon}) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.symmetric(horizontal: 60),
      child: ColoredButton(
          customDisabledColor: CupertinoColors.systemGrey,
          onPressed: onPressed,
          fillColor: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(
                width: 10,
              ),
              Text(text,),
            ],
          )),
    );
  }
}

