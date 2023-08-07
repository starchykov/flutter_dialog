# Flutter dialog

Implementation of Flutter dialog.

Overview:


<img alt="img.png" src="https://github.com/starchykov/flutter_dialog/blob/main/assets/screenshot_1.png" width="400"/><img alt="img.png" src="https://github.com/starchykov/flutter_dialog/blob/main/assets/screenshot_2.png" width="400"/>

The repository [starchykov/context_menu](https://github.com/starchykov/context_menu) provides a context menu for Flutter projects. Here's how you can use it:

### Overview

The repository offers a context menu widget that can be used in Flutter applications. Here's a visual representation of the context menu:

![Context Menu](https://github.com/starchykov/context_menu/blob/main/assets/Screenshot_1661554576.png)

### Basic Usage

You can create a context menu by using the `ContextMenu` widget and providing a list of actions. Here's an example:

```dart
ContextMenu(
  bottomOffsetHeight: 8,
  borderRadius: 8,
  actions: [
    ContextMenuAction(title: 'Share', icon: IconData, onPress: () {}),
    ContextMenuAction(title: 'Copy', icon: IconData, onPress: () {}),
    ContextMenuAction(title: 'Delete', icon: IconData, negativeAction: true, onPress: () {})
  ],
  child: ChildWidget()
),
```

### Context Menu Widget

The `ContextMenu` widget accepts several parameters to customize its appearance and behavior:

- `child`: The widget that can be "opened" with the context menu.
- `actions`: The actions that are shown in the menu, typically `ContextMenuAction`s.
- `menuActionHeight`: Height of the menu actions (default is 50.0).
- `menuWidth`: Width of the context menu (default is equal to the child widget width).
- `borderRadius`: Border radius of the context menu (default is 20).
- `bottomOffsetHeight`: Top context menu indent (default is 0).
- `showByTap`: If true, the context menu can be opened by tap (default is false).

### Context Menu Action

The `ContextMenuAction` class represents an individual action in the context menu. It accepts the following parameters:

- `title`: Menu action title widget.
- `icon`: Trailing icon.
- `onPress`: Menu action callback function.
- `backgroundColor`: Menu widget background color.
- `negativeAction`: If true, the action is considered a negative action (e.g., delete).

### Getting Started

You can find the main entry point of the application in the `lib/main.dart` file, where the `MyApp` class is defined. The `GalleryPage` class in `lib/ui/gallery_page.dart` demonstrates how to use the context menu with a gallery of photos.

For more details and customization options, you can refer to the code in the `lib/ui/context_menu.dart` file.

This should provide you with a good starting point to integrate and use the context menu in your Flutter project. If you're new to Flutter, you may also find the [official Flutter documentation](https://docs.flutter.dev/) helpful.