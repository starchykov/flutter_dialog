import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog/common/no_data_display.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/dialog/context_menu.dart';
import 'package:flutter_dialog/dialog/message_item.dart';
import 'package:flutter_dialog/dialog/messages_page.dart';
import 'package:flutter_dialog/models/message_model.dart';

class CommentsList extends StatefulWidget {
  final List<Message> comments;
  final ScrollController controller;

  const CommentsList({Key? key, required this.comments, required this.controller}) : super(key: key);

  @override
  State<CommentsList> createState() => CommentsListState();

  static CommentsListState? of(BuildContext context) => context.findAncestorStateOfType<CommentsListState>();
}

class CommentsListState extends State<CommentsList> {
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
      await CommentPage.of(context)?.loadComments();
    }
  }

  /// Show available actions for selected message
  void _showContextMenu({required GlobalKey key, required bool current, required int index}) {
    HapticFeedback.mediumImpact();
    setState(() {
      if (_isContextMenuOpen) return _contextMenu.remove();
      _contextMenu = _createContextMenu(key: key, index: index, current: current);
      Overlay.of(context)?.insert(_contextMenu);
      _isContextMenuOpen = !_isContextMenuOpen;
    });
  }

  /// Close actions panel
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
        onTap: () => _closeContextMenu(),
        child: ContextMenu(
          globalKey: key,
          index: index,
          current: current,
          message: widget.comments[index],
          onClose: _closeContextMenu,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool currentUser(String user) => 'John' == user;
    if (widget.comments.isEmpty) return const NoDataToDisplay(text: 'No data', top: 60);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        controller: widget.controller,
        reverse: true,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: widget.comments.length,
        padding: const EdgeInsets.symmetric(vertical: kDefaultTextSpace, horizontal: 10),
        itemBuilder: (context, index) {
          bool isCurrent = currentUser(widget.comments[index].userName);
          return MessageItem(
            isOpen: _isContextMenuOpen,
            isCurrent: currentUser(widget.comments[index].userName),
            onPress: ({required GlobalKey key}) => _showContextMenu(key: key, current: isCurrent, index: index),
            messageItem: widget.comments[index],
          );
        },
      ),
    );
  }
}
