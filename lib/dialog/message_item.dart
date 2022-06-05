import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog/common/responsive.dart';
import 'package:flutter_dialog/common/wrapper.dart';
import 'package:flutter_dialog/models/message_model.dart';

class MessageItem extends StatelessWidget {
  final bool isOpen;
  final bool isCurrent;
  final Function onPress;
  final Message messageItem;

  const MessageItem({
    Key? key,
    required this.isOpen,
    required this.isCurrent,
    required this.onPress,
    required this.messageItem,
  }) : super(key: key);

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
    GlobalKey key = LabeledGlobalKey(messageItem.creationDate.hashCode.toString());
    return MaterialWrapper(
      isCurrent: isCurrent,
      tl: isCurrent ? 20 : 0,
      tr: isCurrent ? 0 : 20,
      color: (isCurrent ? Colors.lightGreen : Colors.grey[400])!,
      widget: InkWell(
        key: key,
        onLongPress: () async => isOpen ? () {} : await onPress(key: key),
        child: SizedBox(
          width: _length(context, messageItem.message),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        messageItem.message,
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                textDirection: isCurrent ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Text(
                    messageItem.creationDate,
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: messageItem.isPending == 1,
                    child: Row(
                      children: const <Widget>[
                        SizedBox(width: 2),
                        CupertinoActivityIndicator(radius: 6),
                        SizedBox(width: 5),
                        Text('Pending...', style: TextStyle(fontSize: 11, color: Colors.black45)),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: messageItem.isPending == 2,
                    child: Row(
                      children: const <Widget>[
                        SizedBox(width: 2),
                        Icon(CupertinoIcons.info_circle, size: 12, color: Colors.redAccent),
                        SizedBox(width: 5),
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
