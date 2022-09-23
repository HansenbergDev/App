import 'package:flutter/cupertino.dart';

class ColoredButton extends CupertinoButton {
  const ColoredButton({
    super.key,
    required super.child,
    required super.onPressed,
    required this.fillColor,
    required this.customDisabledColor
  });

  const ColoredButton.filled({
    super.key, 
    required super.child,
    required super.onPressed,
    required this.fillColor,
    required this.customDisabledColor
  })
      : super.filled();

  final Color? fillColor;
  final Color customDisabledColor;

  @override
  Color? get color => fillColor;
  
  @override
  Color get disabledColor => customDisabledColor;
  

  @override
  EdgeInsetsGeometry? get padding => EdgeInsets.zero;
}
