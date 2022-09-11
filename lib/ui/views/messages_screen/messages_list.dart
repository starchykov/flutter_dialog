import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog/ui/widgets/no_data_display.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/ui/widgets/context_menu.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_item.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_state.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_view_model.dart';
import 'package:provider/provider.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessagesScreenViewModel viewModel = context.read<MessagesScreenViewModel>();
    MessagesScreenState state = context.select((MessagesScreenViewModel viewModel) => viewModel.state);
    if (state.messages.isEmpty) return const NoDataToDisplay(text: 'No data', top: 60);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        controller: viewModel.scrollController,
        reverse: true,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: state.messages.length,
        padding: const EdgeInsets.symmetric(vertical: kDefaultTextSpace, horizontal: 10),
        itemBuilder: (context, index) {
          bool isCurrent = viewModel.currentUser(state.messages[index].userName);
          return GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              // Note: Sensitivity is integer used when you don't want to mess up vertical drag
              int sensitivity = 50;
              if (details.delta.dx > sensitivity) {
                // Right Swipe
                HapticFeedback.heavyImpact();
              } else if (details.delta.dx < -sensitivity) {
                //Left Swipe
                HapticFeedback.heavyImpact();
              }
            },
            child: Row(
              mainAxisAlignment: isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                ContextMenu(
                  menuActionHeight: 45.0,
                  menuWidth: MediaQuery.of(context).size.width * .5,
                  bottomOffsetHeight: kDefaultTextSpace,
                  actions: [
                    if (state.messages[index].isPending == 2)
                      ContextMenuAction(
                        icon: CupertinoIcons.arrow_up_circle,
                        title: 'Resent',
                        onPress: () {},
                      ),
                    ContextMenuAction(
                      icon: CupertinoIcons.doc_on_clipboard,
                      title: 'Copy',
                      onPress: () {},
                    ),
                    ContextMenuAction(
                      icon: CupertinoIcons.delete,
                      title: 'Delete',
                      negativeAction: true,
                      onPress: () {},
                    ),
                  ],
                  child: MessageItem(isCurrent: isCurrent, messageItem: state.messages[index]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
