import 'package:flutter/cupertino.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: CupertinoTheme.of(context).barBackgroundColor,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CupertinoButton(
              minSize: kDefaultDoubleOffset * 4.5,
              padding: EdgeInsets.zero,
              onPressed: () => state.messageText.isEmpty ? null : viewModel.sendMessage(),
              child: const Icon(
                CupertinoIcons.paperclip,
                color: CupertinoColors.inactiveGray,
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: CupertinoColors.secondarySystemFill,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    CupertinoTextField(
                      padding: const EdgeInsets.only(left: 8, right: 28, top: 8, bottom: 8),
                      minLines: viewModel.maxLines(),
                      maxLines: 5,
                      placeholder: 'Message',
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
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
                            ? const Icon(CupertinoIcons.keyboard, color: CupertinoColors.inactiveGray)
                            : const Icon(CupertinoIcons.smiley, color: CupertinoColors.inactiveGray),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: kDefaultTextSpace),
            CupertinoButton(
              minSize: kDefaultDoubleOffset * 4.5,
              padding: EdgeInsets.zero,
              onPressed: () => state.messageText.isEmpty ? null : viewModel.sendMessage(),
              child: Icon(
                CupertinoIcons.arrow_up_circle_fill,
                size: kDefaultDoubleOffset * 4.5,
                color: viewModel.isInputEmpty ? CupertinoColors.systemBlue.withOpacity(.5) : CupertinoColors.systemBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
