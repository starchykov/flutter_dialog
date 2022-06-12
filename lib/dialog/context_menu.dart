import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/models/message_model.dart';

import 'message_actions.dart';
import 'message_item.dart';

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
  static ContextMenuState? of(BuildContext context) => context.findAncestorStateOfType<ContextMenuState>();
}

class ContextMenuState extends State<ContextMenu> {
  late RenderBox renderBox;
  late Offset offset;
  late double offsetY;

  late Size screen;

  late bool _isFloatingOpen;
  late List<MenuActions> _availableActions;

  @override
  void initState() {
    super.initState();
  }

  void _configureContextMenu() {
    _isFloatingOpen = false;
    _availableActions = [MenuActions.copy, MenuActions.delete];
    screen = MediaQuery.of(context).size;

    if (widget.message.isPending == 0) _availableActions.add(MenuActions.copy);
    if (widget.message.isPending == 0) _availableActions.add(MenuActions.delete);
    if (widget.message.isPending == 2) _availableActions.add(MenuActions.resent);
    int count = _availableActions.length;

    setState(() {
      renderBox = widget.globalKey.currentContext?.findRenderObject() as RenderBox;
      final double messageHeight = renderBox.size.height;

      /// Calculate message position
      offset = renderBox.localToGlobal(Offset.zero);
      final bool lastItem = offset.dy > (screen.height - messageHeight - 100);

      /// Wrapper margin/padding(50) + (acton height * item count) + (divider height * item count)
      offsetY = lastItem ? (offset.dy - (50 + (30 * count) + (11 * (count - 1)))) : (offset.dy - 20);
    });
  }

  /// Copy note to clipboard
  Future _copyNote({required int index}) async {
    log('Copy action', name: runtimeType.toString());
    HapticFeedback.heavyImpact();
    await Clipboard.setData(ClipboardData(text: widget.message.message));
    widget.onClose();
  }

  /// Copy note to clipboard
  Future _deleteNote({required int index}) async {
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
          top: offsetY,
          child: Column(
            textDirection: widget.current ? TextDirection.ltr : TextDirection.ltr,
            crossAxisAlignment: widget.current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: offset.dy > screen.height - (renderBox.size.height + 100),
                child: MessageActions(
                  index: widget.index,
                  current: widget.current,
                  onCopy: ({required int index}) async => await _copyNote(index: index),
                  onDelete: ({required int index}) async => await _deleteNote(index: index),
                  onResent: widget.message.isPending == 2
                      ? ({required int index}) async => await _deleteNote(index: index)
                      : null,
                ),
              ),
              MessageItem(
                isOpen: _isFloatingOpen,
                isCurrent: widget.current,
                messageItem: widget.message,
              ),
              Visibility(
                visible: !(offset.dy > screen.height - (renderBox.size.height + 100)),
                child: MessageActions(
                  index: widget.index,
                  current: widget.current,
                  onCopy: ({required int index}) async => await _copyNote(index: index),
                  onDelete: ({required int index}) async => await _deleteNote(index: index),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
