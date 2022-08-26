import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app/Widgets/ColoredCupertinoButton.dart';

class StaffTile extends StatelessWidget {
  const StaffTile({
    Key? key,
    required this.title,
    required this.text,
    required this.button
  }) : super(key: key);

  final String title;
  final String? text;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(
              minHeight: 50, maxHeight: 500, maxWidth: 250, minWidth: 250
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  flex: 200,
                  child: Text(
                    text ?? "",
                    style: const TextStyle(fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          button ?? Container()
        ],
      ),
    );
  }


}
