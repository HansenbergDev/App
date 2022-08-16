import 'package:flutter/cupertino.dart';

enum EnlistStates { none, enlisted, rejected }

class MenuTile extends StatefulWidget {
  const MenuTile(
      {Key? key,
        required this.dateString,
        required this.menuText,
        required this.enlistForDinner,
        required this.rejectDinner})
      : super(key: key);

  final String dateString;
  final String menuText;
  final VoidCallback enlistForDinner;
  final VoidCallback rejectDinner;

  @override
  State<MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  EnlistStates _state = EnlistStates.none;

  @override
  Widget build(BuildContext context) {
    Color enlistButtonFillColor = _state == EnlistStates.enlisted
        ? CupertinoColors.systemGreen
        : CupertinoColors.systemGrey2;
    Color enlistButtonIconColor = _state == EnlistStates.enlisted
        ? CupertinoColors.white
        : CupertinoColors.black;
    Color rejectButtonFillColor = _state == EnlistStates.rejected
        ? CupertinoColors.systemRed
        : CupertinoColors.systemGrey2;
    Color rejectButtonIconColor = _state == EnlistStates.rejected
        ? CupertinoColors.white
        : CupertinoColors.black;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(minHeight: 150, maxHeight: 500, maxWidth: 250, minWidth: 250),
            // color: CupertinoColors.systemBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.dateString, style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  flex: 200,
                  child: Text(widget.menuText),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            children: [
              makeSquareButton(
                  widget.enlistForDinner,
                  EnlistStates.enlisted,
                  CupertinoIcons.check_mark,
                  enlistButtonIconColor,
                  enlistButtonFillColor),
              const SizedBox(
                height: 20,
              ),
              makeSquareButton(
                  widget.rejectDinner,
                  EnlistStates.rejected,
                  CupertinoIcons.clear,
                  rejectButtonIconColor,
                  rejectButtonFillColor)
            ],
          )
        ],
      ),
    );
  }

  Widget makeSquareButton(
      VoidCallback fn, EnlistStates setStateTo, icon, iconColor, fillColor) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ColoredButton.filled(
          onPressed: () => setState(() {
            fn();
            _state = setStateTo;
          }),
          fillColor: fillColor,
          child: Icon(
            icon,
            color: iconColor,
          )
      ),
    );
  }
}

class ColoredButton extends CupertinoButton {
  const ColoredButton(
      {super.key,
        required super.child,
        required super.onPressed,
        required this.fillColor});
  const ColoredButton.filled(
      {super.key,
        required super.child,
        required super.onPressed,
        required this.fillColor})
      : super.filled();

  final Color? fillColor;

  @override
  Color? get color => fillColor;

  @override
  EdgeInsetsGeometry? get padding => EdgeInsets.zero;
}
