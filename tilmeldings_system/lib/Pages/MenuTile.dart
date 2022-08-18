import 'package:flutter/cupertino.dart';

import '../Controllers/ColoredCupertinoButton.dart';
import '../Utilities/util.dart';

class MenuTile extends StatelessWidget {
  const MenuTile(
      {Key? key,
      required this.dateString,
      required this.menuText,
      required this.enlistmentState,
      required this.enlistForDinner,
      required this.rejectDinner})
      : super(key: key);

  final String dateString;
  final String menuText;
  final EnlistmentStates enlistmentState;
  final VoidCallback enlistForDinner;
  final VoidCallback rejectDinner;

  @override
  Widget build(BuildContext context) {
    Color enlistButtonFillColor = enlistmentState == EnlistmentStates.enlisted
        ? CupertinoColors.systemGreen
        : CupertinoColors.systemGrey2;
    Color enlistButtonIconColor = enlistmentState == EnlistmentStates.enlisted
        ? CupertinoColors.white
        : CupertinoColors.black;
    Color rejectButtonFillColor = enlistmentState == EnlistmentStates.rejected
        ? CupertinoColors.systemRed
        : CupertinoColors.systemGrey2;
    Color rejectButtonIconColor = enlistmentState == EnlistmentStates.rejected
        ? CupertinoColors.white
        : CupertinoColors.black;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(
                minHeight: 150, maxHeight: 500, maxWidth: 250, minWidth: 250),
            // color: CupertinoColors.systemBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  dateString,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  flex: 200,
                  child: Text(menuText),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            children: [
              makeSquareButton(enlistForDinner, CupertinoIcons.check_mark,
                  enlistButtonIconColor, enlistButtonFillColor),
              const SizedBox(
                height: 20,
              ),
              makeSquareButton(rejectDinner, CupertinoIcons.clear,
                  rejectButtonIconColor, rejectButtonFillColor)
            ],
          )
        ],
      ),
    );
  }

  Widget makeSquareButton(VoidCallback fn, icon, iconColor, fillColor) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ColoredButton.filled(
          onPressed: fn,
          fillColor: fillColor,
          child: Icon(
            icon,
            color: iconColor,
          )),
    );
  }
}
