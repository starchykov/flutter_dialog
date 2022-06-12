import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'messages_page.dart';

class MessagesInput extends StatefulWidget {
  const MessagesInput({Key? key}) : super(key: key);

  @override
  MessagesInputState createState() => MessagesInputState();
}

class MessagesInputState extends State<MessagesInput> {
  final _addFormKey = GlobalKey<FormState>();
  final _inputMessageController = TextEditingController();
  bool _sending = false;

  String? _commentValidate({required String value}) {
    if (value.isEmpty) return 'Error';
    if (value.length >= 500) return 'Error';
    return null;
  }

  void _onPressSent() {
    _commentValidate(value: _inputMessageController.text);
    if (_addFormKey.currentState!.validate()) _sendMessage();
  }

  Future _sendMessage() async {
    setState(() => _sending = true);
    _addFormKey.currentState!.reset();
    //Message commentModel = Message('Ivan', _textCommentController.text, 0, DateTime.now().toString());
    //await _commentController.createComment(commentModel);
    await MessagesPage.of(context)!.loadComments();

    setState(() {
      _inputMessageController.text = '';
      _sending = false;
    });
  }

  bool _isInputEmpty() => _inputMessageController.text.isEmpty;

  int _maxLines() {
    if (_inputMessageController.value.text.length <= 36) return 1;
    if ((_inputMessageController.value.text.length / 40 + 1).round() >= 5) return 5;
    return (_inputMessageController.value.text.length / 40 + 1).round();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: CupertinoColors.lightBackgroundGray,
        child: Form(
          key: _addFormKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.paperclip, color: Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: CupertinoTextField(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minLines: _maxLines(),
                    maxLines: 5,
                    placeholder: 'Message',
                    onChanged: (_) => setState(() {}),
                    controller: _inputMessageController,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ClipOval(
                  child: Material(
                    color: _isInputEmpty() ? Colors.lightGreen.withOpacity(.5) : Colors.lightGreen,
                    child: InkWell(
                      onTap: () => _isInputEmpty() || _sending ? null : _onPressSent(),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: _sending
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
