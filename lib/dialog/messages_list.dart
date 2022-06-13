import 'package:flutter/material.dart';
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
  late OverlayEntry _contextMenu;

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

  T? getInherit<T>(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<DataMessageProvider>();
    final inheritWidget = element?.widget;
    if (inheritWidget is T) return inheritWidget as T;
    return null;
  }

  Future _scrollListener() async {
    if (_scroll.offset >= _scroll.position.maxScrollExtent && !_scroll.position.outOfRange) {}
    if (_scroll.offset <= _scroll.position.minScrollExtent && !_scroll.position.outOfRange) {
      await MessagesPage.of(context)?.loadFromAPI();
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
          message: _messages[index],
          onClose: _closeContextMenu,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool currentUser(String user) => 'John' == user;
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
          return MessageItem(
            isOpen: _isContextMenuOpen,
            isCurrent: currentUser(_messages[index].userName),
            onPress: ({required GlobalKey key}) => _showContextMenu(key: key, current: isCurrent, index: index),
            messageItem: _messages[index],
          );
        },
      ),
    );
  }
}
