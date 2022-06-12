import 'package:flutter/material.dart';

class MaterialWrapper extends StatelessWidget {
  final Widget widget;
  final Color color;
  final bool isCurrent;
  final double bottomLeft;
  final double topLeft;
  final double bottomRight;
  final double topRight;

  const MaterialWrapper({
    Key? key,
    required this.widget,
    this.color = Colors.lightGreen,
    required this.isCurrent,
    this.bottomLeft = 20,
    this.topLeft = 20,
    this.bottomRight = 20,
    this.topRight = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        key: Key(widget.toString().hashCode.toString()),
        mainAxisAlignment: isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(left: isCurrent ? 35 : 0, top: 5, right: isCurrent ? 0 : 35, bottom: 5),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(bottomLeft),
                  bottomRight: Radius.circular(bottomRight),
                  topLeft: Radius.circular(topLeft),
                  topRight: Radius.circular(topRight),
                ),
              ),
              child: widget,
            ),
          ),
        ],
      );
}
