import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/ui/widgets/wrapper.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/models/message_model.dart';

class MessageItem extends StatelessWidget {
  final bool isCurrent;
  final Message messageItem;

  const MessageItem({
    Key? key,
    required this.isCurrent,
    required this.messageItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      alignment: isCurrent ? MessageAlignment.end : MessageAlignment.start,
      color: isCurrent ? kSuccessColor : kDarkGrayColor,
      message: ConstrainedBox(
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        messageItem.message,
                        style: const TextStyle(color: CupertinoColors.white),
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
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .tabLabelTextStyle
                        .merge(TextStyle(color: CupertinoColors.white.withOpacity(.6))),
                  ),
                  const SizedBox(width: kDefaultTextSpace * 2),
                  const Spacer(),
                  Visibility(
                    visible: messageItem.isPending == 1,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(width: 2),
                        const CupertinoActivityIndicator(radius: 6),
                        const SizedBox(width: kDefaultTextSpace),
                        // Text('Pending...', style: TextStyle(fontSize: 11, color: Colors.black45)),
                        Text(
                          'Pending...',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .tabLabelTextStyle
                              .merge(TextStyle(color: CupertinoColors.black.withOpacity(.4))),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: messageItem.isPending == 2,
                    child: Row(
                      children: [
                        const SizedBox(width: 2),
                        const Icon(CupertinoIcons.info_circle, size: 12, color: CupertinoColors.destructiveRed),
                        const SizedBox(width: kDefaultTextSpace),
                        Text(
                          'Not sent',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .tabLabelTextStyle
                              .merge(TextStyle(color: CupertinoColors.black.withOpacity(.4))),
                        ),
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
