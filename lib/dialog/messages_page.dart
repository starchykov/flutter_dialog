import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog/dialog/messages_input.dart';
import 'package:flutter_dialog/models/message_model.dart';

import 'messages_list.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  State<CommentPage> createState() => CommentPageState();

  static CommentPageState? of(BuildContext context) => context.findAncestorStateOfType<CommentPageState>();
}

class CommentPageState extends State<CommentPage> {
  //final CommentController api = CommentController();
  final GlobalKey<ScaffoldMessengerState> msgKey = GlobalKey<ScaffoldMessengerState>();
  List<Message> commentList = [];
  late Future<List<Message>> _future;
  final ScrollController _controller = ScrollController();

  /// Define loading flag
  bool loading = true;

  @override
  void initState() {
    loadCommentsFromDB();
    super.initState();
  }

  Future loadComments() async {
    setState(() => loading = true);

    /// Get request to server, save response data to database
    //await api.getDataFromRequest(globalCaseId);

    /// Get list of DocumentModel from database
    await loadCommentsFromDB();

    /// Show message after update
    //String statStr = api.getStatisticString(context);
    //msgKey.currentState.showSnackBar(CustomSnackBar().UploadInfoSnackBar(statStr, msgKey.currentContext));
  }

  Future<List<Message>> loadCommentsFromDB() async {
    /// Get list of DocumentModel from database
    // List<dynamic> dataDB = await api.getDataFromDB(globalCaseId);
    ///List<Message> list = new List<Message>.from(dataDB.whereType<Message>());

    List<Message> list = [
      const Message('Ivan', 'Hello Hello Hello Hello! Hello Hello Hello Hello!Hello Hello Hello Hello!Hello Hello Hello Hello!Hello Hello Hello Hello!Hello Hello Hello Hello!', 1, '15.05.2022'),
      const Message('Anton', 'Hello Hello Hello Hello!', 0, '15.05.2022'),
      const Message('Kota', 'Hello Hello Hello Hello!', 0, '15.05.2022'),
      const Message('Ivan', 'Hello Hello Hello Hello!', 1, '15.05.2022'),
      const Message('Keks', 'Hello Hello Hello Hello!', 0, '15.05.2022'),
      const Message('Ivan', 'Hello Hello Hello Hello!', 0, '15.05.2022'),
      const Message('Ivan', 'Hello Hello Hello Hello!', 0, '15.05.2022'),
      const Message('Ivan', 'Hello Hello Hello Hello!', 0, '15.05.2022'),
      const Message('Ivan', 'Hello Hello Hello Hello!', 0, '15.05.2022'),
      const Message('Ivan', 'Hello Hello Hello Hello 123 4 ! ', 1, '15.05.2022'),
    ];

    /// Set actual data from database to state. Let loading flag to false
    setState(() {
      commentList = list;
      loading = false;
    });
    return _future = Future.value(list);
  }

  /// Check availability of the Internet connection
  Future<void> createComment() async {
    //String msg = 'No Internet';
    //ApplicationUser.user.isOfflineMode
    //     ? msgKey.currentState.showSnackBar(CustomSnackBar().UploadErrorSnackBar(msg, msgKey.currentContext))
    //     : await loadComments();
  }

  @override
  Widget build(BuildContext context) => ScaffoldMessenger(
        key: msgKey,
        child: CupertinoPageScaffold(
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) => Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: CommentsList(comments: commentList, controller: _controller)),
                    const AddComment()
                  ],
                ),
                if (loading)
                  Align(
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
              ],
            ),
          ),
        ),
      );
}
