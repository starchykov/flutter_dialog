import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_input.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_list.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_loading.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_view_model.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

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
          automaticallyImplyLeading: true,
          previousPageTitle: 'Dialogs',
          middle: const Text('Messages'),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: const [
                  Expanded(child: MessagesList()),
                  MessagesInput(),
                ],
              ),
              const MessageLoading(),
            ],
          ),
        ),
      ),
    );
  }
}
