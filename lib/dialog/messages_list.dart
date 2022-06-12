import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog/common/no_data_display.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/dialog/context_menu.dart';
import 'package:flutter_dialog/dialog/messages_item.dart';
import 'package:flutter_dialog/dialog/messages_page.dart';
import 'package:flutter_dialog/models/message_model.dart';

class MessagesList extends StatefulWidget {
  final List<Message> messages;
  final ScrollController controller;

  const MessagesList({Key? key, required this.messages, required this.controller}) : super(key: key);

  @override
  State<MessagesList> createState() => MessagesListState();

  static MessagesListState? of(BuildContext context) => context.findAncestorStateOfType<MessagesListState>();
}

class MessagesListState extends State<MessagesList> {
  bool _isContextMenuOpen = false;
  late ScrollController scroll;
  late OverlayEntry _contextMenu;

  @override
  void initState() {
    widget.controller.addListener((_scrollListener));
    scroll = widget.controller;
    super.initState();
  }

  Future _scrollListener() async {
    if (scroll.offset >= scroll.position.maxScrollExtent && !widget.controller.position.outOfRange) {}
    if (scroll.offset <= scroll.position.minScrollExtent && !scroll.position.outOfRange) {
      await MessagesPage.of(context)?.loadComments();
    }
  }

  void _showContextMenu({required GlobalKey key, required bool current, required int index}) {
    HapticFeedback.mediumImpact();
    setState(() {
      if (_isContextMenuOpen) return _contextMenu.remove();
      _contextMenu = _createContextMenu(key: key, index: index, current: current);
      Overlay.of(context)?.insert(_contextMenu);
      _isContextMenuOpen = !_isContextMenuOpen;
    });
  }

  void _closeContextMenu() {
    if (_isContextMenuOpen == true) {
      _contextMenu.remove();
      setState(() => _isContextMenuOpen = !_isContextMenuOpen);
    }
  }

  OverlayEntry _createContextMenu({required GlobalKey key, required int index, required bool current}) {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeContextMenu,
        child: ContextMenu(
          globalKey: key,
          index: index,
          current: current,
          message: widget.messages[index],
          onClose: _closeContextMenu,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool currentUser(String user) => 'John' == user;
    if (widget.messages.isEmpty) return const NoDataToDisplay(text: 'No data', top: 60);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        controller: widget.controller,
        reverse: true,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: widget.messages.length,
        padding: const EdgeInsets.symmetric(vertical: kDefaultTextSpace, horizontal: 10),
        itemBuilder: (context, index) {
          bool isCurrent = currentUser(widget.messages[index].userName);
          return MessageItem(
            isOpen: _isContextMenuOpen,
            isCurrent: currentUser(widget.messages[index].userName),
            onPress: ({required GlobalKey key}) => _showContextMenu(key: key, current: isCurrent, index: index),
            messageItem: widget.messages[index],
          );
        },
      ),
    );
  }
}
