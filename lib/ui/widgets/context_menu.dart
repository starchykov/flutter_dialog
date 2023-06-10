import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum Blur {blured, clear}

/// The ContextMenuAlignment enum represents two possible alignments for a context menu: start and end.
/// It can be used to define the alignment of a context menu based on the UI requirements.
enum ContextMenuAlignment {start, end}

class ContextMenuAction {
  /// Menu action title widget.
  ///
  /// Example: const Text('Copy')
  final String title;

  /// Trailing icon.
  ///
  /// Example: const Icon(CupertinoIcons.doc_on_clipboard)
  final IconData? icon;

  /// Menu action callback function.
  ///
  /// Example: Function _func(param: val)
  final Function onPress;

  /// Menu widget background color.
  ///
  /// Example: const Colors.white
  final Color? backgroundColor;

  /// Menu widget background color.
  ///
  /// Example: const Colors.white
  final bool? negativeAction;


  /// The menu that displays when ContextMenu is open.
  /// It consists of a list of actions.
  const ContextMenuAction({
    required this.title,
    required this.onPress, this.icon,
    this.backgroundColor,
    this.negativeAction,
  });
}

class ContextMenu extends StatefulWidget {

  const ContextMenu({
    required this.child, required this.actions, super.key,
    this.menuActionHeight,
    this.menuWidth,
    this.borderRadius,
    this.childOffset,
    this.menuOffset,
    this.bottomOffsetHeight,
    this.showByTap = false,
    this.blur = Blur.blured,
    this.alignment = ContextMenuAlignment.end,
  });

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

  /// [ContextMenu] child widget indent can be configured.
  ///
  /// Default [ContextMenuAction]s indent is 0
  final double? childOffset;

  /// All side[ContextMenu] indent can be configured.
  ///
  /// Default [ContextMenuAction]s indent is 0
  final double? menuOffset;

  /// Top [ContextMenu] indent can be configured.
  ///
  /// Default [ContextMenuAction]s indent is 0
  final double? bottomOffsetHeight;

  /// [ContextMenu] width.
  ///
  /// Default [ContextMenu] width is equal to child widget width
  final double? menuWidth;

  /// [ContextMenu] border radius.
  ///
  /// Default [ContextMenu]s border radius is 20
  final double? borderRadius;

  /// [ContextMenu] can be opened by tap if [showByTap] is true.
  /// By default it's opened by long press.
  ///
  /// Default [showByTap] value is false
  final bool showByTap;

  final Blur blur;
  final ContextMenuAlignment alignment;

  @override
  State<ContextMenu> createState() => ContextMenuState();
}

/// This is the stateful widget for creating a context menu.
/// It extends the State class and is parameterized with the generic type ContextMenu.
class ContextMenuState extends State<ContextMenu> {
  final GlobalKey containerKey = GlobalKey();
  Offset childOffset = const Offset(0, 0);
  late Size childSize;
  late bool _isContextMenuOpen;
  late OverlayEntry _contextMenu;

  @override
  void initState() {
    super.initState();
    /// Initialize the state variables.
    _isContextMenuOpen = false;
    /// Add a post-frame callback to ensure that the layout is complete before initializing the context menu.
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  /// This function is called after the layout is complete to configure the context menu.
  void _afterLayout(Duration duration) => _configureContextMenu();

  /// This function configures the position and size of the context menu based on the position and size of the child widget.
  void _configureContextMenu() {
    /// Find the render object of the container using its global key.
    final RenderBox renderBox = containerKey.currentContext?.findRenderObject() as RenderBox;
    /// Get the size and position of the child widget.
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    /// Update the state variables.
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  /// TThis function is responsible for creating an overlay entry for the context menu.
  OverlayEntry _createContextMenu() => OverlayEntry(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeContextMenu,
          child: _ContextMenu(
            actions: widget.actions,
            isBlur: widget.blur,
            alignment: widget.alignment,
            childOffset: childOffset,
            childSize: childSize,
            menuWidth: widget.menuWidth,
            bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
            borderRadius: widget.borderRadius ?? 10,
            menuOffset: widget.menuOffset ?? 0,
            menuActionHeight: widget.menuActionHeight,
            onPress: _closeContextMenu,
            child: widget.child,
          ),
        ),
      );

  /// This function is responsible for the context menu showing.
  void _showContextMenu() {
    /// Configure the context menu.
    _configureContextMenu();
    /// Trigger haptic feedback.
    HapticFeedback.mediumImpact();
    /// Update the state variables to show or hide the context menu.
    setState(() {
      if (_isContextMenuOpen) return _contextMenu.remove();
      _contextMenu = _createContextMenu();
      Overlay.of(context).insert(_contextMenu);
      _isContextMenuOpen = !_isContextMenuOpen;
    });
  }

  /// This function is responsible for the context menu closing.
  void _closeContextMenu() {
    if (_isContextMenuOpen == true) {
      _contextMenu.remove();
      setState(() => _isContextMenuOpen = !_isContextMenuOpen);
    }
  }

  /// This widget returns a GestureDetector with the child widget wrapped inside a container with a global key.
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => widget.showByTap ? _showContextMenu() : null,
        onLongPress: () => widget.showByTap ? null : _showContextMenu(),
        child: Container(key: containerKey, child: widget.child),
      );
}

class _ContextMenu extends StatelessWidget {
  const _ContextMenu({
    required this.child,
    required this.childSize,
    required this.childOffset,
    required this.actions,
    required this.borderRadius,
    required this.bottomOffsetHeight,
    required this.menuOffset,
    required this.onPress,
    required this.isBlur,
    required this.alignment,
    this.menuActionHeight,
    this.menuWidth,
  });

  final Widget child;
  final List<ContextMenuAction> actions;
  final Size childSize;
  final Offset childOffset;
  final double? menuActionHeight;
  final double? menuWidth;
  final double borderRadius;
  final double bottomOffsetHeight;
  final double menuOffset;
  final Function onPress;
  final ContextMenuAlignment alignment;
  final Blur isBlur;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    const double screenPadding = 16;

    final maxMenuHeight = size.height * 0.5;
    final listHeight = actions.length * (menuActionHeight ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.4);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;

    final leftOffset = (childOffset.dx + maxMenuWidth + menuOffset) < size.width
        ? childOffset.dx + menuOffset
        : (childOffset.dx - maxMenuWidth + childSize.width - menuOffset);

    final actionsOffset = childOffset.dy + menuHeight + childSize.height;
    final screenSize = size.height - bottomOffsetHeight - keyboardHeight - screenPadding;

    final topOffset = actionsOffset < screenSize
        ? childOffset.dy + childSize.height + menuOffset + bottomOffsetHeight
        : childOffset.dy - menuHeight - menuOffset - bottomOffsetHeight;

    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(height: MediaQuery.of(context).size.height, color: CupertinoColors.separator),
        ),
        Positioned(
          top: topOffset,
          left:  alignment == ContextMenuAlignment.start ? leftOffset : null,
          right: alignment == ContextMenuAlignment.end ? leftOffset : null,
          child: Container(
            clipBehavior: Clip.antiAlias,
            width: maxMenuWidth,
            height: menuHeight,
            decoration: BoxDecoration(
              color: CupertinoTheme.of(context).scaffoldBackgroundColor.withOpacity(.5),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              boxShadow: const [BoxShadow(color: CupertinoColors.secondarySystemFill, blurRadius: 10, spreadRadius: 1)],
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: ListView.builder(
                itemCount: actions.length,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      onPress();
                      actions[index].onPress();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 1),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: actions[index].backgroundColor ??
                          CupertinoTheme.of(context).scaffoldBackgroundColor.withOpacity(.3),
                      height: menuActionHeight ?? 45.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            actions[index].title,
                            style: CupertinoTheme.of(context).textTheme.textStyle.merge(
                                  TextStyle(
                                    color: actions[index].negativeAction ?? false
                                        ? CupertinoColors.destructiveRed
                                        : CupertinoTheme.of(context).textTheme.textStyle.color,
                                  ),
                                ),
                          ),
                          Visibility(
                            visible: actions[index].icon != null,
                            child: Icon(
                              actions[index].icon,
                              color: actions[index].negativeAction ?? false
                                  ? CupertinoColors.destructiveRed
                                  : CupertinoTheme.of(context).primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: childOffset.dy,
          left: childOffset.dx,
          child: AbsorbPointer(
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
