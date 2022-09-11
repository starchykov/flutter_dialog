import 'package:flutter/material.dart';
import 'package:flutter_dialog/constants/constants.dart';

class MaterialWrapper extends StatelessWidget {
  /// Widget which will be wrapper by decoration wrapper.
  /// Value cann not be null.
  final Widget widget;

  /// [Material] decoration [Color] value.
  /// Default [Color] is [Colors.lightGreen].
  final Color? color;

  /// [Material] decoration [BorderRadius] bottom left border value.
  /// Default [BorderRadius] value 20.
  final double? borderBL;

  /// [Material] decoration [BorderRadius] top left border value.
  /// Default [BorderRadius] value 20.
  final double? borderTL;

  /// [Material] decoration [BorderRadius] bottom right border value.
  /// Default [BorderRadius] value 20.
  final double? borderBR;

  /// [Material] decoration [BorderRadius] top left right value.
  /// Default [BorderRadius] value 20.
  final double? borderTR;

  /// Wrapper for messages instance widget. Wrapper has default margin (top: 5, bottom: 5)
  /// and default padding (vertical: 15, horizontal: 15).
  const MaterialWrapper({
    Key? key,
    required this.widget,
    this.color,
    this.borderBL,
    this.borderTL,
    this.borderBR,
    this.borderTR,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(top: kDefaultTextSpace, bottom: kDefaultTextSpace),
          padding: const EdgeInsets.symmetric(vertical: kDefaultDoubleBoxPadding, horizontal: kDefaultDoubleBoxPadding),
          decoration: BoxDecoration(
            color: color ?? kBackgroundBlue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderBL ?? kDefaultBorderRadius),
              bottomRight: Radius.circular(borderBR ?? kDefaultBorderRadius),
              topLeft: Radius.circular(borderTL ?? kDefaultBorderRadius),
              topRight: Radius.circular(borderTR ?? kDefaultBorderRadius),
            ),
          ),
          child: widget,
        ),
      );
}
