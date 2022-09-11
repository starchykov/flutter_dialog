import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoDataToDisplay extends StatelessWidget {
  final String text;

  /// Additional required space on top
  /// Change value according to navigationBar and AppBar
  final double top;

  const NoDataToDisplay({Key? key, required this.text, this.top = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
        child: Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height * .35) + (top),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.tray, color: Colors.grey),
              const SizedBox(width: 10),
              Text(text, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
      );
}
