import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContextMenuAction {
  /// Menu action title widget.
  ///
  /// Example: const Text('Copy')
  final Widget title;

  /// Menu action callback function.
  ///
  /// Example: Function _func(param: val)
  final Function onPress;

  /// Trailing icon.
  ///
  /// Example: const Icon(CupertinoIcons.doc_on_clipboard)
  final Icon? icon;

  /// Menu widget background color.
  ///
  /// Example: const Colors.white
  final Color? backgroundColor;

  /// The menu that displays when ContextMenu is open. It consists of a
  /// list of actions.
  const ContextMenuAction({
    required this.title,
    required this.onPress,
    this.icon,
    this.backgroundColor,
  });
}

class ContextMenu extends StatefulWidget {
  /// The widget that can be "opened" with the [ContextMenu].
  ///
  /// When the [ContextMenu] is long-pressed (tapped or if [showByTap] is 'true'), the menu will open and
  /// this widget will  be moved to the new route and placed inside of an [OverlayEntry] widget.
  ///
  /// When the [ContextMenu] is "closed", this widget acts like a
  /// [Container], i.e. it does not constrain its child's size or affect its
  /// position.
  ///
  /// This parameter cannot be null.
  final Widget child;

  /// The actions that are shown in the menu.
  ///
  /// These actions are typically [ContextMenuAction]s.
  ///
  /// This parameter cannot be null or empty.
  final List<ContextMenuAction> actions;

  /// [ContextMenuAction]s height can be configured.
  ///
  /// Default [ContextMenuAction]s height is 50.0
  final double? menuActionHeight;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final double? menuWidth;
  final bool showByTap;

  const ContextMenu({
    Key? key,
    required this.child,
    required this.actions,
    this.menuActionHeight,
    this.menuWidth,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.showByTap = false,
  }) : super(key: key);

  @override
  State<ContextMenu> createState() => ContextMenuState();
}

class ContextMenuState extends State<ContextMenu> {
  final GlobalKey containerKey = GlobalKey();
  Offset childOffset = const Offset(0, 0);
  late Size childSize;
  late bool _isContextMenuOpen;
  late OverlayEntry _contextMenu;

  @override
  void initState() {
    super.initState();
    _isContextMenuOpen = false;
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(Duration duration) => _configureContextMenu();

  void _configureContextMenu() {
    RenderBox renderBox = containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  /// Copy note to clipboard
  // Future _copyMessage({required int index}) async {
  //   log('Copy action', name: runtimeType.toString());
  //   HapticFeedback.heavyImpact();
  //   // await Clipboard.setData(ClipboardData(text: widget.message.message));
  //   widget.onClose();
  // }

  /// Copy note to clipboard
  // Future _deleteMessage({required int index}) async {
  //   log('Delete action', name: runtimeType.toString());
  //   HapticFeedback.heavyImpact();
  //   widget.onClose();
  // }

  OverlayEntry _createContextMenu() => OverlayEntry(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeContextMenu,
          child: _ContextMenu(
            actions: widget.actions,
            childOffset: childOffset,
            childSize: childSize,
            menuWidth: widget.menuWidth,
            bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
            menuOffset: widget.menuOffset ?? 0,
            menuActionHeight: widget.menuActionHeight,
            onPress: _closeContextMenu,
            child: widget.child,
          ),
        ),
      );

  void _showContextMenu() {
    _configureContextMenu();
    HapticFeedback.mediumImpact();
    setState(() {
      if (_isContextMenuOpen) return _contextMenu.remove();
      _contextMenu = _createContextMenu();
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

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => widget.showByTap ? _showContextMenu() : null,
        onLongPress: () => widget.showByTap ? null : _showContextMenu(),
        child: Container(key: containerKey, child: widget.child),
      );
}

class _ContextMenu extends StatelessWidget {
  final Widget child;
  final List<ContextMenuAction> actions;
  final Size childSize;
  final Offset childOffset;
  final double? menuActionHeight;
  final double? menuWidth;
  final double bottomOffsetHeight;
  final double menuOffset;
  final Function onPress;

  const _ContextMenu({
    Key? key,
    required this.child,
    required this.childSize,
    required this.childOffset,
    required this.actions,
    this.menuActionHeight,
    this.menuWidth,
    required this.bottomOffsetHeight,
    required this.menuOffset,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = actions.length * (menuActionHeight ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.4);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;

    // final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
    //     ? childOffset.dx
    //     : (childOffset.dx - maxMenuWidth + childSize.width);

    final actionsOffset = childOffset.dy + menuHeight + childSize.height;
    final screenSize = size.height - bottomOffsetHeight - keyboardHeight;

    final topOffset = actionsOffset < screenSize
        ? childOffset.dy + childSize.height + menuOffset
        : childOffset.dy - menuHeight - menuOffset;

    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(height: MediaQuery.of(context).size.height, color: Colors.black45),
        ),
        Positioned(
          top: topOffset,
          left: childOffset.dx,
          child: Container(
            clipBehavior: Clip.antiAlias,
            width: maxMenuWidth,
            height: menuHeight,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 1)],
            ),
            child: ListView.builder(
              itemCount: actions.length,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  onPress();
                  actions[index].onPress();
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 1),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  color: actions[index].backgroundColor ?? Colors.white,
                  height: menuActionHeight ?? 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      actions[index].title,
                      Visibility(
                        visible: actions[index].icon != null,
                        child: actions[index].icon!,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: childOffset.dy,
          left: childOffset.dx,
          child: AbsorbPointer(
            absorbing: true,
            child: SizedBox(
              width: childSize.width,
              height: childSize.height,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
