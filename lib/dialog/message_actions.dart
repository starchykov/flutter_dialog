import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog/common/wrapper.dart';

class MessageActions extends StatelessWidget {
  final int index;
  final bool current;
  final Function onCopy;
  final Function? onDelete;
  final Function? onResent;

  const MessageActions({
    Key? key,
    required this.index,
    required this.current,
    required this.onCopy,
    this.onDelete,
    this.onResent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialWrapper(
      isCurrent: current,
      color: Colors.white,
      widget: Column(
        mainAxisSize: MainAxisSize.max,
        textDirection: current ? TextDirection.rtl : TextDirection.ltr,
        children: [
          ActionItem(
              icon: const Icon(CupertinoIcons.arrow_up_circle, color: Colors.black54, size: 20),
              text: 'Resent',
              action: onResent,
              index: index,
          ),
          ActionItem(
            icon: const Icon(CupertinoIcons.doc_on_clipboard, color: Colors.black54, size: 20),
            text: 'Copy',
            action: onCopy,
            index: index,
          ),
          ActionItem(
            icon: const Icon(CupertinoIcons.delete, color: Colors.redAccent, size: 20),
            text: 'Delete',
            action: onDelete,
            index: index,
            last: true,
          ),
        ],
      ),
    );
  }
}

class ActionItem extends StatelessWidget {
  const ActionItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.action,
    required this.index,
    this.last = false,
  }) : super(key: key);

  final Icon icon;
  final String text;
  final Function? action;
  final int index;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: action != null,
      child: InkWell(
        onTap: () async => await action!(index: index),
        child: Column(
          children: [
            SizedBox(
              width: 100,
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(text)),
                  icon,
                ],
              ),
            ),
            Visibility(
              visible: !last,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(height: 1, width: 100, color: Colors.black26),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
