import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_input.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_list.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_loading.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_view_model.dart';
import 'package:provider/provider.dart';

/// A screen for displaying messages.
///
/// This screen provides a list of messages and allows users to interact with them.
class MessagesScreen extends StatelessWidget {

  /// Creates a new instance of the [MessagesScreen] class.
  ///
  /// The [key] parameter is an optional key that can be used to identify this widget.
  const MessagesScreen({super.key});

  /// Renders the [MessagesScreen] widget.
  ///
  /// This method creates a [ChangeNotifierProvider] and returns the [MessagesScreen] wrapped in the provider.
  static Widget render() {
    return ChangeNotifierProvider(
      create: (context) => MessagesScreenViewModel(),
      child: const MessagesScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: CupertinoPageScaffold(
        navigationBar:  CupertinoNavigationBar(
          backgroundColor: CupertinoTheme.of(context).barBackgroundColor.withOpacity(.6),
          previousPageTitle: 'Dialogs',
          middle: const Text('Messages'),
        ),
        child: const SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: MessagesList()),
                  MessagesInput(),
                ],
              ),
              MessageLoading(),
            ],
          ),
        ),
      ),
    );
  }
}
