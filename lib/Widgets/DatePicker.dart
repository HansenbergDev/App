// Modified from https://api.flutter.dev/flutter/cupertino/CupertinoPicker-class.html

import 'package:flutter/cupertino.dart';

import '../Utilities/util.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key, required this.title, required this.fontSize, required this.callback}) : super(key: key);

  final String title;
  final double fontSize;
  final Function callback;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {

  DateTime _date = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _DatePickerItem(
        children: <Widget>[
          Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold),),
          CupertinoButton(
            // Display a CupertinoDatePicker in date picker mode.
            onPressed: () => _showDialog(
              CupertinoDatePicker(
                initialDateTime: _date,
                mode: CupertinoDatePickerMode.date,
                use24hFormat: true,
                // This is called when the user changes the date.
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _date = newDate;
                    widget.callback(_date);
                  });
                },
              ),
            ),
            // In this example, the date value is formatted manually. You can use intl package
            // to format the value based on user's locale settings.
            child: Text(
              '${_date.day < 10 ? "0${_date.day}" : _date.day}-${_date.month < 10 ? "0${_date.month}" : _date.month}-${_date.year}',
              style: TextStyle(
                fontSize: widget.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: createBoxShadow()
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}