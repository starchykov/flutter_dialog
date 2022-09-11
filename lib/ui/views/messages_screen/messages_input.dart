import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_state.dart';

import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_view_model.dart';
import 'package:provider/provider.dart';

class MessagesInput extends StatelessWidget {
  const MessagesInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessagesScreenViewModel viewModel = context.read<MessagesScreenViewModel>();
    MessagesScreenState state = context.select((MessagesScreenViewModel viewModel) => viewModel.state);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: CupertinoColors.lightBackgroundGray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => state.messageText.isEmpty ? null : viewModel.sendMessage(),
            child: const SizedBox(
              width: 30,
              height: 30,
              child: const Icon(CupertinoIcons.paperclip, color: CupertinoColors.placeholderText),
            ),
          ),
          const SizedBox(width: kDefaultTextSpace),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  CupertinoTextField(
                    padding: const EdgeInsets.only(left: 8, right: 28, top: 8, bottom: 8),
                    minLines: viewModel.maxLines(),
                    maxLines: 5,
                    placeholder: 'Message',
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    onChanged: (messageText) => viewModel.onMessageInputPrint(messageText: messageText),
                    controller: viewModel.inputMessageController,
                  ),
                  Positioned(
                    bottom: 7,
                    right: 8,
                    child: GestureDetector(
                      onTap: viewModel.showStickers,
                      child: state.showStickers
                          ? Icon(CupertinoIcons.keyboard, color: CupertinoColors.placeholderText)
                          : Icon(CupertinoIcons.smiley, color: CupertinoColors.placeholderText),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ClipOval(
              child: Container(
                color: viewModel.isInputEmpty ? CupertinoColors.systemBlue.withOpacity(.5) : CupertinoColors.systemBlue,
                child: GestureDetector(
                  onTap: () => state.messageText.isEmpty ? null : viewModel.sendMessage(),
                  child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(CupertinoIcons.arrow_up, size: 20, color: CupertinoColors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
