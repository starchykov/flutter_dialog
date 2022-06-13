import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/dialog/messages_input.dart';
import 'package:flutter_dialog/dialog/messages_inherit.dart';
import 'package:flutter_dialog/dialog/messages_loading.dart';
import 'package:flutter_dialog/models/message_model.dart';

import 'messages_list.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => MessagesPageState();

  static MessagesPageState? of(BuildContext context) => context.findAncestorStateOfType<MessagesPageState>();
}

class MessagesPageState extends State<MessagesPage> {
  List<Message> messages = <Message>[];
  bool _loading = true;
  int number = 1;

  /// Test data
  List<Message> testDataList = [
    const Message('John', 'This is not sent message with long text: text text text text text text', 2, '15.05.2022'),
    const Message('Olexei', 'Hello Hello Hello Hello!', 0, '15.05.2022'),
    const Message('John', 'This is long text message: text text text text text text text text text', 1, '15.05.2022'),
    const Message('John', 'This is example of the Flutter dialog!', 0, '15.05.2022'),
    const Message('John', 'Hello! ', 1, '15.05.2022'),
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future loadFromAPI() async {
    log('Loading from API', name: 'Message page');
    setState(() => _loading = true);
    await _loadMessages();
  }

  Future<List<Message>> _loadMessages() async {
    log('Loading from database', name: 'Message page');

    setState(() {
      messages = testDataList;
      _loading = false;
    });
    return Future.value(testDataList);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CupertinoPageScaffold(
          child: DataMessageProvider(
            loading: _loading,
            messages: [...messages],
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
