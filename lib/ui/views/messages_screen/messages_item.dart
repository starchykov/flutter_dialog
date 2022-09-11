import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog/ui/widgets/wrapper.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/models/message_model.dart';

class MessageItem extends StatelessWidget {
  final bool isCurrent;
  final Function? onPress;
  final Message messageItem;

  const MessageItem({
    Key? key,
    required this.isCurrent,
    this.onPress,
    required this.messageItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialWrapper(
      borderTL: isCurrent ? 20 : 0,
      borderTR: isCurrent ? 0 : 20,
      color: isCurrent ? Colors.lightGreen : Colors.grey[400],
      widget: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * .2,
          maxWidth: MediaQuery.of(context).size.width * .8,
        ),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: kDefaultTextSpace),
                child: Row(
                  mainAxisAlignment: isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        messageItem.message,
                        style: const TextStyle(color: Colors.white),
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
                    style: Theme.of(context).textTheme.caption!.merge(const TextStyle(color: Colors.white60)),
                  ),
                  const SizedBox(width: kDefaultTextSpace),
                  const Spacer(),
                  Visibility(
                    visible: messageItem.isPending == 1,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(width: 2),
                        const CupertinoActivityIndicator(radius: 6),
                        const SizedBox(width: kDefaultTextSpace),
                        // Text('Pending...', style: TextStyle(fontSize: 11, color: Colors.black45)),
                        Text('Pending...', style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: messageItem.isPending == 2,
                    child: Row(
                      children: [
                        const SizedBox(width: 2),
                        const Icon(CupertinoIcons.info_circle, size: 12, color: Colors.redAccent),
                        const SizedBox(width: kDefaultTextSpace),
                        Text('Not sent', style: Theme.of(context).textTheme.caption),
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
