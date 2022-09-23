import 'package:flutter/cupertino.dart';

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
  final bool? enlistmentState;
  final VoidCallback enlistForDinner;
  final VoidCallback rejectDinner;

  @override
  Widget build(BuildContext context) {

    Color enlistButtonFillColor;
    Color enlistButtonIconColor;

    Color rejectButtonFillColor;
    Color rejectButtonIconColor;

    enlistButtonFillColor = rejectButtonFillColor = CupertinoColors.systemGrey3;
    enlistButtonIconColor = rejectButtonIconColor = CupertinoColors.black;

    if (enlistmentState != null) {
      if (enlistmentState!) {
        enlistButtonFillColor = CupertinoColors.systemGreen;
        enlistButtonIconColor = CupertinoColors.white;
      }
      else {
        rejectButtonFillColor = CupertinoColors.systemRed;
        rejectButtonIconColor = CupertinoColors.white;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: createBoxShadow()
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(
                minHeight: 150, maxHeight: 500, maxWidth: 250, minWidth: 250
            ),
            // color: CupertinoColors.systemBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  dateString,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  flex: 200,
                  child: Text(
                    menuText,
                    style: const TextStyle(fontSize: 15),
                  ),
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
}
