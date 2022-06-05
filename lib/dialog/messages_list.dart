import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog/common/no_data_display.dart';
import 'package:flutter_dialog/dialog/message_actions.dart';
import 'package:flutter_dialog/dialog/message_item.dart';
import 'package:flutter_dialog/dialog/messages_page.dart';
import 'package:flutter_dialog/models/message_model.dart';

enum Actions {
  resent,
  cancelsending,
  copy,
  delete,
}

class CommentsList extends StatefulWidget {
  final List<Message> comments;
  final ScrollController controller;

  const CommentsList({Key? key, required this.comments, required this.controller}) : super(key: key);

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  /// Work page actions state
  bool _isFloatingOpen = false;
  late OverlayEntry _floating;
  List<Actions> availableActions = [Actions.copy, Actions.delete];

  @override
  void initState() {
    widget.controller.addListener((_scrollListener));
    super.initState();
  }

  Future _scrollListener() async {
    if (widget.controller.offset >= widget.controller.position.maxScrollExtent && !widget.controller.position.outOfRange) {}
    if (widget.controller.offset <= widget.controller.position.minScrollExtent && !widget.controller.position.outOfRange) {
      await CommentPage.of(context)?.loadComments();
    }
  }

  /// Show available actions for selected message
  void _showActions({required GlobalKey key, required bool current, required int index}) {
    HapticFeedback.heavyImpact();
    setState(() {
      if (_isFloatingOpen) return _floating.remove();
      _floating = _createFloating(key: key, index: index, current: current);
      Overlay.of(context)?.insert(_floating);
      _isFloatingOpen = !_isFloatingOpen;
    });
  }

  /// Close actions panel
  void _closeActions() {
    if (_isFloatingOpen == true) {
      _floating.remove();
      setState(() => _isFloatingOpen = !_isFloatingOpen);
    }
  }

  /// Copy note to clipboard
  Future _copyNote({required int index}) async {
    log('Copy action', name: runtimeType.toString());
    HapticFeedback.heavyImpact();
    await Clipboard.setData(ClipboardData(text: widget.comments[index].message));
    _closeActions();
  }

  /// Copy note to clipboard
  Future _deleteNote({required int index}) async {
    log('Delete action', name: runtimeType.toString());
    HapticFeedback.heavyImpact();
    _closeActions();
  }

  OverlayEntry _createFloating({required GlobalKey key, required int index, required bool current}) {
    availableActions = [Actions.copy, Actions.delete];
    if (widget.comments[index].isPending == 0) availableActions.add(Actions.copy);
    if (widget.comments[index].isPending == 0) availableActions.add(Actions.delete);
    if (widget.comments[index].isPending == 2) availableActions.add(Actions.resent);
    int count = availableActions.length;

    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final double messageHeight = renderBox.size.height;

    /// Calculate message position
    final Size screen = MediaQuery.of(context).size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final bool lastItem = offset.dy > (screen.height - messageHeight - 100);

    /// Wrapper margin/padding(50) + (acton height * item count) + (divider height * item count)
    final double offsetY = lastItem ? (offset.dy - (50 + (30 * count) + (11 * (count - 1)))) : (offset.dy - 20);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _closeActions(),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(height: MediaQuery.of(context).size.height, color: Colors.black45),
            ),
            Positioned(
              left: current ? 0 : 10,
              right: current ? 10 : 0,
              top: offsetY,
              child: Column(
                textDirection: current ? TextDirection.ltr : TextDirection.ltr,
                crossAxisAlignment: current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: offset.dy > screen.height - (renderBox.size.height + 100),
                    child: MessageActions(
                      index: index,
                      current: current,
                      onCopy: ({required int index}) async => await _copyNote(index: index),
                      onDelete: ({required int index}) async => await _deleteNote(index: index),
                      onResent: widget.comments[index].isPending == 2
                          ? ({required int index}) async => await _deleteNote(index: index)
                          : null,
                    ),
                  ),
                  MessageItem(
                    isOpen: _isFloatingOpen,
                    isCurrent: current,
                    onPress: ({required GlobalKey key}) => _showActions(key: key, current: current, index: index),
                    messageItem: widget.comments[index],
                  ),
                  Visibility(
                    visible: !(offset.dy > screen.height - (renderBox.size.height + 100)),
                    child: MessageActions(
                      index: index,
                      current: current,
                      onCopy: ({required int index}) async => await _copyNote(index: index),
                      onDelete: ({required int index}) async => await _deleteNote(index: index),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        itemBuilder: (context, index) {
          bool isCurrent = currentUser(widget.comments[index].userName);
          return MessageItem(
            isOpen: _isFloatingOpen,
            isCurrent: currentUser(widget.comments[index].userName),
            onPress: ({required GlobalKey key}) => _showActions(key: key, current: isCurrent, index: index),
            messageItem: widget.comments[index],
          );
        },
      ),
    );
  }
}
