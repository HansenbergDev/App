
import 'package:flutter/cupertino.dart';

import '../Widgets/TopNotification.dart';

class Notifications {
  static void _showNotification({required BuildContext context, required String text, required Color backgroundColor, required Color textColor, required Duration duration}) {
    final entry = OverlayEntry(builder: (context) {
      return TopNotification(text: text, backgroundColor: backgroundColor, textColor: textColor,);
    });

    Navigator.of(context).overlay!.insert(entry);

    Future.delayed(duration, () {
      entry.remove();
    });
  }

  static void showAlert({required BuildContext context, required String text, Duration duration = const Duration(seconds: 2)}) {
    _showNotification(
        context: context,
        text: text,
        backgroundColor: CupertinoColors.destructiveRed,
        textColor: CupertinoColors.white,
        duration: duration
    );
  }

  static void showConfirmation({required BuildContext context, required String text, Duration duration = const Duration(seconds: 2)}) {
    _showNotification(
        context: context,
        text: text,
        backgroundColor: CupertinoColors.systemGreen,
        textColor: CupertinoColors.white,
        duration: duration
    );
  }
}

