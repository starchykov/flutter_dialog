import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_input.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_list.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_loading.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_view_model.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  static Widget render() {
    return ChangeNotifierProvider(
      create: (context) => MessagesScreenViewModel(),
      child: const MessagesScreen(),
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          bottom: false,
          child: CupertinoPageScaffold(
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
