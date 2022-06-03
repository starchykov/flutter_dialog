import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog/models/message_model.dart';

import 'messages_page.dart';

class AddComment extends StatefulWidget {
  const AddComment({Key? key}) : super(key: key);

  @override
  AddCommentState createState() => AddCommentState();
}

class AddCommentState extends State<AddComment> {
  final _addFormKey = GlobalKey<FormState>();

  // CommentController _commentController = CommentController();
  final _textCommentController = TextEditingController();
  bool sending = false;

  /// Check the input value. If there are no characters, an error is returned
  String? commentValidate({required String value}) {
    if (value.isEmpty) return 'Error';
    if (value.length >= 500) return 'Error';
    return null;
  }

  /// Add comment handler
  void addComment() {
    commentValidate(value: _textCommentController.text);
    if (_addFormKey.currentState!.validate()) onPressComment();
  }

  Future onPressComment() async {
    setState(() => sending = true);
    _addFormKey.currentState!.save();
    //Message commentModel = Message('Ivan', _textCommentController.text, 0, DateTime.now().toString());
    //await _commentController.createComment(commentModel);
    CommentPage.of(context)!.loadComments().then((value) => setState(() {
          _textCommentController.text = '';
          sending = false;
        }));
  }

  /// Check is input empty
  bool isEmpty() => _textCommentController.text.isEmpty;

  int maxLines() {
    if (_textCommentController.value.text.length <= 36) return 1;
    if ((_textCommentController.value.text.length / 40 + 1).round() >= 5) return 5;
    return (_textCommentController.value.text.length / 40 + 1).round();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Colors.grey[100],
        child: Form(
          key: _addFormKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.paperclip, color: Colors.grey),
              SizedBox(width: 5),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: CupertinoTextField(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minLines: maxLines(),
                    maxLines: 5,
                    placeholder: 'Message',
                    onChanged: (_) => setState(() {}),
                    controller: _textCommentController,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.all(5),
                child: ClipOval(
                  child: Material(
                    color: isEmpty() ? Colors.lightGreen.withOpacity(.5) : Colors.lightGreen,
                    child: InkWell(
                      onTap: () => isEmpty() || sending ? null : addComment(),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: sending
                            ? const CupertinoActivityIndicator()
                            : const Icon(CupertinoIcons.arrow_up, size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
