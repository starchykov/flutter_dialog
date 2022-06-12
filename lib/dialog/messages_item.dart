import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog/common/responsive.dart';
import 'package:flutter_dialog/common/wrapper.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/models/message_model.dart';

class MessageItem extends StatefulWidget {
  final bool isOpen;
  final bool isCurrent;
  final Function? onPress;
  final Message messageItem;

  const MessageItem({
    Key? key,
    this.isOpen = true,
    required this.isCurrent,
    this.onPress,
    required this.messageItem,
  }) : super(key: key);

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late final GlobalKey key;

  @override
  void initState() {
    super.initState();
    key = LabeledGlobalKey(widget.messageItem.message.hashCode.toString());
  }

  double _length(BuildContext context, String text) {
    double screenWidth = MediaQuery.of(context).size.width;
    double messageWidth;

    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);

    if (isTablet && text.length < 25) return messageWidth = (screenWidth * .15) - 10;
    if (isTablet && text.length > 25 && text.length <= 90) return messageWidth = (text.length * 8).toDouble();
    if (isTablet && text.length >= 90) return messageWidth = (screenWidth * .5) - 10;

    if (isMobile && text.length < 25) return messageWidth = (screenWidth * .37);
    if (isMobile && text.length >= 25 && text.length <= 50) return messageWidth = (text.length * 6).toDouble();
    if (isMobile && text.length >= 50) return messageWidth = (screenWidth * .8) - 10;

    messageWidth = screenWidth * .5;

    return messageWidth;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialWrapper(
      isCurrent: widget.isCurrent,
      topLeft: widget.isCurrent ? 20 : 0,
      topRight: widget.isCurrent ? 0 : 20,
      color: (widget.isCurrent ? Colors.lightGreen : Colors.grey[400])!,
      widget: InkWell(
        key: key,
        onLongPress: () async => widget.isOpen && widget.onPress != null ? () {} : await widget.onPress!(key: key),
        child: SizedBox(
          width: _length(context, widget.messageItem.message),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: kDefaultTextSpace),
                child: Row(
                  mainAxisAlignment: widget.isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        widget.messageItem.message,
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                textDirection: widget.isCurrent ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Text(
                    widget.messageItem.creationDate,
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: widget.messageItem.isPending == 1,
                    child: Row(
                      children: const <Widget>[
                        SizedBox(width: 2),
                        CupertinoActivityIndicator(radius: 6),
                        SizedBox(width: kDefaultTextSpace),
                        Text('Pending...', style: TextStyle(fontSize: 11, color: Colors.black45)),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.messageItem.isPending == 2,
                    child: Row(
                      children: const <Widget>[
                        SizedBox(width: 2),
                        Icon(CupertinoIcons.info_circle, size: 12, color: Colors.redAccent),
                        SizedBox(width: kDefaultTextSpace),
                        Text('Not sent', style: TextStyle(fontSize: 11, color: Colors.black45)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
