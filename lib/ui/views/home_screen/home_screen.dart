import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>  CupertinoPageScaffold(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        navigationBar: const CupertinoNavigationBar(
          automaticallyImplyLeading: true,
          previousPageTitle: 'Dialogs',
          middle: Text('Messages'),
        ),
        child: MessagesScreen.render(),
      );
}