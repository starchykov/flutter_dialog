import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog/dialog/messages_input.dart';
import 'package:flutter_dialog/models/message_model.dart';

import 'messages_list.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => MessagesPageState();

  static MessagesPageState? of(BuildContext context) => context.findAncestorStateOfType<MessagesPageState>();
}

class MessagesPageState extends State<MessagesPage> {
  final GlobalKey<ScaffoldMessengerState> messagesPageKey = GlobalKey<ScaffoldMessengerState>();
  List<Message> _messages = <Message>[];
  late Future<List<Message>> _future;
  final ScrollController _controller = ScrollController();
  bool _loading = true;

  @override
  void initState() {
    _loadMessages();
    super.initState();
  }

  Future loadComments() async {
    setState(() => _loading = true);
    await _loadMessages();
  }

  Future<List<Message>> _loadMessages() async {
    List<Message> list = [
      const Message(
          'John', 'This is not sent message with long text: text text text text text text text text', 2, '15.05.2022'),
      const Message('Olexei', 'Hello Hello Hello Hello!', 0, '15.05.2022'),
      const Message(
          'John', 'This is long text message: text text text text text text text text text text text', 1, '15.05.2022'),
      const Message('John', 'This is example of the Flutter dialog!', 0, '15.05.2022'),
      const Message('John', 'Hello! ', 1, '15.05.2022'),
    ];

    /// Set actual data from database to state. Let loading flag to false
    setState(() {
      _messages = list;
      _loading = false;
    });
    return _future = Future.value(list);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: ScaffoldMessenger(
          key: messagesPageKey,
          child: CupertinoPageScaffold(
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) => Stack(
                children: [
                  Column(
                    children: [
                      Expanded(child: MessagesList(messages: _messages, controller: _controller)),
                      const MessagesInput()
                    ],
                  ),
                  Visibility(
                    visible: _loading,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * .5,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoActivityIndicator(color: Colors.grey[500]),
                            const SizedBox(width: 15),
                            Text('Loading', style: TextStyle(color: Colors.grey[500])),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
