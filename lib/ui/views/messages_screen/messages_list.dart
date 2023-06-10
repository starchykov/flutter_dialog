import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/models/message_model.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_item.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_state.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_view_model.dart';
import 'package:flutter_dialog/ui/widgets/context_menu.dart';
import 'package:flutter_dialog/ui/widgets/no_data_display.dart';
import 'package:provider/provider.dart';

/// A widget that displays a list of messages.
class MessagesList extends StatelessWidget {

  /// Constructs a [MessagesList] instance.
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    /// Obtain the view model instance from the context to access data and trigger state changes.
    final MessagesScreenViewModel viewModel = context.read<MessagesScreenViewModel>();

    /// Obtain the current state from the view model using `select` method, which
    /// allows selectively listening to changes in specific parts of the view model.
    final MessagesScreenState state = context.select((MessagesScreenViewModel viewModel) => viewModel.state);

    /// Return NoDataToDisplay if the List of messages from the state is empty.
    if (state.messages.isEmpty) return const NoDataToDisplay(text: 'No data', top: 60);

    /// Build a ListView widget to display the list of messages based on the
    /// current state or other data.
    return ListView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.symmetric(vertical: kTextSpaceDefault, horizontal: 8),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: viewModel.scrollController,
      reverse: true,
      children: state.messages.map((Message message) {
        final bool isCurrent = viewModel.isCurrentUser(message.userName);
        return ContextMenu(
          menuActionHeight: 45,
          menuWidth: MediaQuery.of(context).size.width * .5,
          bottomOffsetHeight: kTextSpaceDefault,
          alignment: isCurrent ? ContextMenuAlignment.end : ContextMenuAlignment.start,
          actions: [
            if (message.isPending == 2)
              ContextMenuAction(
                icon: CupertinoIcons.arrow_up_circle,
                title: 'Resent',
                onPress: () {},
              ),
            ContextMenuAction(
              icon: CupertinoIcons.doc_on_clipboard,
              title: 'Copy',
              onPress: () => viewModel.copyMessage(message: message),
            ),
            ContextMenuAction(
              icon: CupertinoIcons.delete,
              title: 'Delete',
              negativeAction: true,
              onPress: () => viewModel.deleteMessage(message: message),
            ),
          ],
          child: MessageItem(isCurrent: isCurrent, messageItem: message),
        );
      }).toList(),
    );
  }
}
