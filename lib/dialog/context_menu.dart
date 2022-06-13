import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/models/message_model.dart';

import 'message_actions.dart';
import 'messages_item.dart';

class ContextMenu extends StatefulWidget {
  final GlobalKey globalKey;
  final int index;
  final bool current;
  final Message message;
  final Function onClose;

  const ContextMenu({
    Key? key,
    required this.globalKey,
    required this.index,
    required this.current,
    required this.message,
    required this.onClose,
  }) : super(key: key);

  @override
  State<ContextMenu> createState() => ContextMenuState();
}

class ContextMenuState extends State<ContextMenu> {
  late Size _screen;
  late RenderBox _renderBox;
  late Offset _offset;
  late bool _isFloatingOpen;
  late List<MenuActions> _availableActions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  bool _isKeyboardVisible() => MediaQuery.of(context).viewInsets.bottom != 0;

  void _afterLayout(dynamic _) => _configureContextMenu();

  void _configureContextMenu() {
    _isFloatingOpen = false;
    _availableActions = [MenuActions.copy, MenuActions.delete];
    _screen = MediaQuery.of(context).size;

    if (widget.message.isPending == 0) _availableActions.add(MenuActions.copy);
    if (widget.message.isPending == 0) _availableActions.add(MenuActions.delete);
    if (widget.message.isPending == 2) _availableActions.add(MenuActions.resent);

    setState(() => _renderBox = widget.globalKey.currentContext?.findRenderObject() as RenderBox);
  }

  double _calcMenuOffset() {
    int count = _availableActions.length;

    /// Calculate message position
    _offset = _renderBox.localToGlobal(Offset.zero);
    final double offsetY;
    final double messageHeight = _renderBox.size.height;
    final bool lastItem = _offset.dy > (_screen.height - messageHeight - 100) || _isKeyboardVisible();

    /// Wrapper margin/padding(50) + (acton height * item count) + (divider height * item count)
    offsetY = lastItem ? (_offset.dy - (50 + (30 * count) + (11 * (count - 1)))) : (_offset.dy - 20);
    return offsetY;
  }

  /// Copy note to clipboard
  Future _copyMessage({required int index}) async {
    log('Copy action', name: runtimeType.toString());
    HapticFeedback.heavyImpact();
    await Clipboard.setData(ClipboardData(text: widget.message.message));
    widget.onClose();
  }

  /// Copy note to clipboard
  Future _deleteMessage({required int index}) async {
    log('Delete action', name: runtimeType.toString());
    HapticFeedback.heavyImpact();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    _configureContextMenu();
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(height: MediaQuery.of(context).size.height, color: Colors.black45),
        ),
        Positioned(
          left: widget.current ? 0 : 10,
          right: widget.current ? 10 : 0,
          top: _calcMenuOffset(),
          child: Column(
            textDirection: widget.current ? TextDirection.ltr : TextDirection.ltr,
            crossAxisAlignment: widget.current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: _offset.dy > _screen.height - (_renderBox.size.height + 100) || _isKeyboardVisible(),
                child: MessageActions(
                  index: widget.index,
                  current: widget.current,
                  onCopy: ({required int index}) async => await _copyMessage(index: index),
                  onDelete: ({required int index}) async => await _deleteMessage(index: index),
                  onResent: widget.message.isPending == 2
                      ? ({required int index}) async => await _deleteMessage(index: index)
                      : null,
                ),
              ),
              MessageItem(
                isOpen: _isFloatingOpen,
                isCurrent: widget.current,
                messageItem: widget.message,
              ),
              Visibility(
                visible: !(_offset.dy > _screen.height - (_renderBox.size.height + 100)) && !_isKeyboardVisible(),
                child: MessageActions(
                  index: widget.index,
                  current: widget.current,
                  onCopy: ({required int index}) async => await _copyMessage(index: index),
                  onDelete: ({required int index}) async => await _deleteMessage(index: index),
                  onResent: widget.message.isPending == 2
                      ? ({required int index}) async => await _deleteMessage(index: index)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
