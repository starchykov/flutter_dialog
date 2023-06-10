import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/models/message_model.dart';
import 'package:flutter_dialog/ui/widgets/wrapper.dart';

/// A widget representing an individual message item.
class MessageItem extends StatelessWidget {

  /// Creates a new instance of the [MessageItem] class.
  ///
  /// The [isCurrent] parameter indicates whether the message is from the current user.
  /// The [messageItem] parameter represents the message to be displayed.
  const MessageItem({
    required this.isCurrent,
    required this.messageItem,
    super.key,
  });

  /// Indicates whether the message is from the current user.
  final bool isCurrent;

  /// The message to be displayed.
  final Message messageItem;

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
                padding: const EdgeInsets.symmetric(vertical: kTextSpaceDefault),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        messageItem.messageText,
                        style: const TextStyle(color: CupertinoColors.white, fontSize: kDefaultFontSize),
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
                  const SizedBox(width: kTextSpaceDefault * 2),
                  const Spacer(),
                  Visibility(
                    visible: messageItem.isPending == 1,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(width: 2),
                        const CupertinoActivityIndicator(radius: 6),
                        const SizedBox(width: kTextSpaceDefault),
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
                        const SizedBox(width: kTextSpaceDefault),
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
