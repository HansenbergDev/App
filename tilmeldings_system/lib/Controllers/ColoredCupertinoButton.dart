import 'package:flutter/cupertino.dart';

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