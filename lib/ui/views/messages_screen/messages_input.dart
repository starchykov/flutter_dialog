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
      padding: const EdgeInsets.symmetric(horizontal: kOffsetDouble, vertical: kOffsetDouble),
      color: CupertinoTheme.of(context).barBackgroundColor,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CupertinoButton(
              minSize: kOffsetDouble * 4.5,
              padding: EdgeInsets.zero,
              onPressed: () => state.messageText.isEmpty ? null : viewModel.sendMessage(),
              child: const Icon(
                CupertinoIcons.paperclip,
                color: kGrayColor,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  CupertinoTextField(
                    padding: const EdgeInsets.only(
                      left: kOffsetDouble,
                      right: kOffsetDouble * 4,
                      top: kOffsetDouble,
                      bottom: kOffsetDouble,
                    ),
                    minLines: viewModel.maxLines(),
                    maxLines: 5,
                    placeholder: 'Message',
                    decoration: const BoxDecoration(
                      color: kBackgroundGray,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    onChanged: (messageText) => viewModel.onMessageInputPrint(messageText: messageText),
                    controller: viewModel.inputMessageController,
                  ),
                  Positioned(
                    bottom: kOffsetDouble - 2,
                    right: kOffsetDouble,
                    child: GestureDetector(
                      onTap: viewModel.showStickers,
                      child: state.showStickers
                          ? const Icon(CupertinoIcons.keyboard, color: kGrayColor)
                          : const Icon(CupertinoIcons.smiley, color: kGrayColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: kTextSpaceDefault),
            CupertinoButton(
              minSize: kOffsetDouble * 4.5,
              padding: EdgeInsets.zero,
              onPressed: () => state.messageText.isEmpty ? null : viewModel.sendMessage(),
              child: Icon(
                CupertinoIcons.arrow_up_circle_fill,
                size: kOffsetDouble * 4.5,
                color: viewModel.isInputEmpty ? kPrimaryColor.withOpacity(.5) : kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
