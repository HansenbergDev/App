import 'package:flutter/cupertino.dart';

class IconCupertinoButtonFilled extends StatelessWidget {
  const IconCupertinoButtonFilled({Key? key, required this.onPressed, required this.text, required this.icon}) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.symmetric(horizontal: 60),
      child: CupertinoButton.filled(
          disabledColor: CupertinoColors.systemGrey,
          onPressed: onPressed,
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
      child: CupertinoButton(
          disabledColor: CupertinoColors.systemGrey,
          onPressed: onPressed,
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

