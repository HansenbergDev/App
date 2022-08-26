import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// From: https://stackoverflow.com/questions/53219599/flutter-notify-from-top-of-the-screen

class TopNotification extends StatefulWidget {
  const TopNotification({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor
  }) : super(key: key);

  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  State<StatefulWidget> createState() => TopNotificationState();
}

class TopNotificationState extends State<TopNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  late Animation<Offset> position;

  @override
  void initState() {
    super.initState();

    position = Tween<Offset>(begin: const Offset(0.0, -2.0), end: Offset.zero)
        .animate(
        CurvedAnimation(parent: controller, curve: Curves.bounceOut));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: SlideTransition(
            position: position,
            child: Container(
              decoration: ShapeDecoration(
                  color: widget.backgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.text,
                  style: TextStyle(
                      color: widget.textColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
