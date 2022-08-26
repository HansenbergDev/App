import 'package:flutter/cupertino.dart';

class TextfieldWithTitle extends StatelessWidget {
  const TextfieldWithTitle({Key? key, required this.title, required this.placeholder, required this.controller}) : super(key: key);

  final String title;
  final String placeholder;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          const SizedBox(height: 10,),
          CupertinoTextField(
            placeholder: placeholder,
            autocorrect: false,
            controller: controller,
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.systemGrey,),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
