import 'package:flutter/material.dart';
import 'package:flutter_dialog/constants/constants.dart';

enum MessageAlignment {start, end}

class Wrapper extends StatelessWidget {
  /// Widget which will be wrapper by decoration wrapper.
  /// Value can not be null.
  final Widget message;

  /// Widget which will be wrapper by decoration wrapper.
  /// Value can not be null.
  final Widget? sticker;

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

  final MessageAlignment alignment;

  /// Wrapper for messages instance widget. Wrapper has default margin (top: 5, bottom: 5)
  /// and default padding (vertical: 15, horizontal: 15).
  const Wrapper({
    Key? key,
    required this.message,
    this.sticker,
    required this.alignment,
    this.color,
    this.borderBL,
    this.borderTL,
    this.borderBR,
    this.borderTR,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment == MessageAlignment.end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        sticker ?? const SizedBox(),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(20.0),
              bottomRight: const Radius.circular(20.0),
              topLeft: Radius.circular(alignment == MessageAlignment.end ? 20.0 : 0),
              topRight: Radius.circular(alignment == MessageAlignment.start ? 20.0 : 0),
            ),
          ),
          child: message,
        ),
      ],
    );
  }
}
