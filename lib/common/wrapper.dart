import 'package:flutter/material.dart';

class MaterialWrapper extends StatelessWidget {
  final Widget widget;
  final Color color;
  final bool isCurrent;
  final double bl;
  final double tl;
  final double br;
  final double tr;

  const MaterialWrapper({
    Key? key,
    required this.widget,
    this.color = Colors.lightGreen,
    required this.isCurrent,
    this.bl = 20,
    this.tl = 20,
    this.br = 20,
    this.tr = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                bottomLeft: Radius.circular(bl),
                bottomRight: Radius.circular(br),
                topLeft: Radius.circular(tl),
                topRight: Radius.circular(tr),
              ),
            ),
            child: widget,
          ),
        ),
      ],
    );
  }
}
