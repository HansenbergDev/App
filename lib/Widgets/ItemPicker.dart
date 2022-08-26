// Modified from https://api.flutter.dev/flutter/cupertino/CupertinoPicker-class.html

import 'package:flutter/cupertino.dart';

class ItemPicker extends StatefulWidget {
  const ItemPicker({Key? key, required this.text, required this.fontSize, required this.list, required this.callback}) : super(key: key);

  final String text;
  final double fontSize;
  final List<String> list;
  final Function callback;

  @override
  State<ItemPicker> createState() => _ItemPickerState();
}

class _ItemPickerState extends State<ItemPicker> {

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }

  int _selectedItem = 0;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.text, style: TextStyle(fontSize: widget.fontSize),),
          CupertinoButton(
            padding: EdgeInsets.zero,
            // Display a CupertinoPicker with list of fruits.
            onPressed: () => _showDialog(
              CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: 32,
                // This is called when selected item is changed.
                onSelectedItemChanged: (int selectedItem) {
                  setState(() {
                    _selectedItem = selectedItem;
                    widget.callback(_selectedItem);
                  });
                },
                children: List<Widget>.generate(widget.list.length,
                        (int index) {
                      return Center(
                        child: Text(
                          widget.list[index],
                        ),
                      );
                    }),
              ),
            ),
            // This displays the selected fruit name.
            child: Text(
              widget.list[_selectedItem],
              style: TextStyle(
                fontSize: widget.fontSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}

