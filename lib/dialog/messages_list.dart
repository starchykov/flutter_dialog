import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog/common/no_data_display.dart';
import 'package:flutter_dialog/common/responsive.dart';
import 'package:flutter_dialog/dialog/messages_page.dart';
import 'package:flutter_dialog/models/message_model.dart';

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

  @override
  void initState() {
    widget.controller.addListener((_scrollListener));
    super.initState();
  }

  Future _scrollListener() async {
    if (widget.controller.offset >= widget.controller.position.maxScrollExtent &&
        !widget.controller.position.outOfRange) {}
    if (widget.controller.offset <= widget.controller.position.minScrollExtent &&
        !widget.controller.position.outOfRange) {
      await CommentPage.of(context)?.loadComments();
    }
  }

  /// Show available actions for selected message
  Future _showActions({required Key key, required bool current, required int index}) async {
    setState(() {
      HapticFeedback.heavyImpact();
      if (_isFloatingOpen) return _floating.remove();
      _floating = _createFloating(key: key, index: index, current: current);
      Overlay.of(context)?.insert(_floating);
      _isFloatingOpen = !_isFloatingOpen;
    });
  }

  /// Close actions panel
  void _closeActions(a, offset) {
    if (a.position.dy < offset.dy || a.position.dy > offset.dy + 150 && _isFloatingOpen) {
      _floating.remove();
      log(a.toString());
      setState(() => _isFloatingOpen = !_isFloatingOpen);
    }
  }

  /// Copy note to clipboard
  Future _copyNote({required int index}) async {
    HapticFeedback.heavyImpact();
    await Clipboard.setData(ClipboardData(text: widget.comments[index].message));
    if (_isFloatingOpen) _floating.remove();
    setState(() => _isFloatingOpen = !_isFloatingOpen);
  }

  /// Copy note to clipboard
  Future _deleteNote({required int index}) async {
    HapticFeedback.heavyImpact();
    if (_isFloatingOpen) _floating.remove();
    setState(() => _isFloatingOpen = !_isFloatingOpen);
  }

  OverlayEntry _createFloating({key, required int index, required bool current}) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset.zero);
    double messageHeight = (renderBox.size.height);
    return OverlayEntry(
      builder: (context) => Listener(
        onPointerDown: (a) => _closeActions(a, offset),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(height: MediaQuery.of(context).size.height, color: Colors.black45),
            ),
            Positioned(
              left: current ? 0 : 10,
              right: current ? 10 : 0,
              top: offset.dy > (MediaQuery.of(context).size.height - messageHeight - 100)
                  ? (offset.dy - 20 - 100)
                  : (offset.dy - 20),
              child: Column(
                textDirection: current ? TextDirection.ltr : TextDirection.ltr,
                crossAxisAlignment: current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: offset.dy > MediaQuery.of(context).size.height - (renderBox.size.height + 100),
                    child: _actions(index: index, current: current),
                  ),
                  _noteItem(index: index, current: current),
                  Visibility(
                    visible: !(offset.dy > MediaQuery.of(context).size.height - (renderBox.size.height + 100)),
                    child: _actions(index: index, current: current),
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
    bool currentUser(String user) => 'Ivan' == user;
    String emptyText = 'no_comments_to_display';
    if (widget.comments.isEmpty) return NoDataToDisplay(text: emptyText, top: 60);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        controller: widget.controller,
        reverse: true,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: widget.comments.length,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        itemBuilder: (context, index) => _noteItem(index: index, current: currentUser(widget.comments[index].userName)),
      ),
    );
  }

  Widget _actions({required bool current, required int index}) => materialWrapper(
        cu: current,
        color: Colors.white,
        widget: Column(
          mainAxisSize: MainAxisSize.max,
          textDirection: current ? TextDirection.rtl : TextDirection.ltr,
          children: [
            InkWell(
              onTap: () async => await _copyNote(index: index),
              child: SizedBox(
                width: 100,
                child: Row(
                  children: const <Widget>[
                    Text('Copy'),
                    Spacer(),
                    Icon(CupertinoIcons.doc_on_clipboard, color: Colors.black54, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(height: 1, width: 100, color: Colors.black26),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async => await _deleteNote(index: index),
              child: SizedBox(
                width: 100,
                child: Row(
                  children: const <Widget>[
                    Text('Delete'),
                    Spacer(),
                    Icon(CupertinoIcons.delete, color: Colors.redAccent, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _noteItem({required bool current, required int index}) {
    GlobalKey key = LabeledGlobalKey(widget.comments[index].creationDate.hashCode.toString());
    return materialWrapper(
      cu: current,
      tl: current ? 20 : 0,
      tr: current ? 0 : 20,
      color: (current ? Colors.lightGreen : Colors.grey[400])!,
      widget: InkWell(
        key: key,
        onLongPress: () async => _isFloatingOpen ? null : await _showActions(key: key, current: current, index: index),
        child: SizedBox(
          width: _length(context, widget.comments[index].message),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: current ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        widget.comments[index].message,
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                textDirection: current ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Text(
                    widget.comments[index].creationDate,
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                  const Spacer(),
                  if (widget.comments[index].isPending == 1)  Row(
                    children: const <Widget>[
                      SizedBox(width: 2),
                      CupertinoActivityIndicator(radius: 6),
                      SizedBox(width: 5),
                      Text('Pending...', style: TextStyle(fontSize: 11, color: Colors.black45)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  /// Material wrapper container
  Widget materialWrapper({
    required Widget widget,
    Color color = Colors.lightGreen,
    required bool cu,
    double bl = 20,
    double tl = 20,
    double br = 20,
    double tr = 20,
  }) {
    return Row(
      key: Key(widget.toString().hashCode.toString()),
      mainAxisAlignment: cu ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.only(left: cu ? 35 : 0, top: 5, right: cu ? 0 : 35, bottom: 5),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(bl),
                bottomRight: Radius.circular(br),
                topLeft: Radius.circular(tl),
                topRight: Radius.circular(tr),
              ),
            ),
            child: widget,
          ),
        ),
      ],
    );
  }
}
