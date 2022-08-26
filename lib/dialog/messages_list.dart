import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog/common/no_data_display.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/dialog/context_menu.dart';
import 'package:flutter_dialog/dialog/messages_item.dart';
import 'package:flutter_dialog/dialog/messages_page.dart';
import 'package:flutter_dialog/dialog/messages_inherit.dart';
import 'package:flutter_dialog/models/message_model.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({Key? key}) : super(key: key);

  @override
  State<MessagesList> createState() => MessagesListState();
}

class MessagesListState extends State<MessagesList> {
  late List<Message> _messages;
  late bool _isContextMenuOpen;
  late ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _isContextMenuOpen = false;
    _scroll = ScrollController();
    _scroll.addListener((_scrollListener));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messages = context.dependOnInheritedWidgetOfExactType<DataMessageProvider>(aspect: 'messages')?.messages ?? [];
  }

  bool currentUser(String user) => 'John' == user;

  Future _scrollListener() async {
    if (_scroll.offset >= _scroll.position.maxScrollExtent && !_scroll.position.outOfRange) {}
    if (_scroll.offset <= _scroll.position.minScrollExtent && !_scroll.position.outOfRange) {
      await MessagesPage.of(context)?.loadFromAPI();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_messages.isEmpty) return const NoDataToDisplay(text: 'No data', top: 60);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        controller: _scroll,
        reverse: true,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: _messages.length,
        padding: const EdgeInsets.symmetric(vertical: kDefaultTextSpace, horizontal: 10),
        itemBuilder: (context, index) {
          bool isCurrent = currentUser(_messages[index].userName);
          return GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              // Note: Sensitivity is integer used when you don't want to mess up vertical drag
              int sensitivity = 50;
              if (details.delta.dx > sensitivity) {
                // Right Swipe
                HapticFeedback.heavyImpact();
              } else if(details.delta.dx < -sensitivity) {
                //Left Swipe
                HapticFeedback.heavyImpact();
              }
            },
            child: Row(
              mainAxisAlignment: isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                ContextMenu(
                  menuActionHeight: 45.0,
                  menuWidth: MediaQuery.of(context).size.width * .45,
                  menuOffset: 5.0,
                  actions: [
                    if (_messages[index].isPending == 2)
                      ContextMenuAction(
                        icon: CupertinoIcons.arrow_up_circle,
                        title: 'Resent',
                        onPress: () {},
                      ),
                    ContextMenuAction(
                      icon: CupertinoIcons.doc_on_clipboard,
                      title: 'Copy',
                      onPress: () {},
                    ),
                    ContextMenuAction(
                      icon: CupertinoIcons.delete,
                      title: 'Delete',
                      negativeAction: true,
                      onPress: () {},
                    ),
                  ],
                  child: MessageItem(
                    isOpen: _isContextMenuOpen,
                    isCurrent: isCurrent,
                    messageItem: _messages[index],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
