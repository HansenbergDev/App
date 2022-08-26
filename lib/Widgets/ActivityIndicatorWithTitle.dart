import 'package:flutter/cupertino.dart';

class ActivityIndicatorWithTitle extends StatelessWidget {
  const ActivityIndicatorWithTitle({Key? key, this.title = "Loading"}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          // Text(title, style: const TextStyle(fontSize: 30),),
          // const SizedBox(height: 20,),
          CupertinoActivityIndicator(radius: 40,)
        ],
      ),
    );
  }
}
