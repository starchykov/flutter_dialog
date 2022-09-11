import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/constants/constants.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_state.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_view_model.dart';
import 'package:provider/provider.dart';

class MessageLoading extends StatelessWidget {
  const MessageLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessagesScreenState state = context.select((MessagesScreenViewModel viewModel) => viewModel.state);
    return Visibility(
      visible: state.loading,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 30,
          width: MediaQuery.of(context).size.width * .5,
          margin: const EdgeInsets.all(kDefaultBoxMargin),
          padding: const EdgeInsets.all(kDefaultTextSpace),
          decoration: const BoxDecoration(
            color: kGrayColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(kDefaultBorderRadius),
              bottomRight: Radius.circular(kDefaultBorderRadius),
              topLeft: Radius.circular(kDefaultBorderRadius),
              topRight: Radius.circular(kDefaultBorderRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CupertinoActivityIndicator(color: kDarkGrayColor, radius: 8),
              SizedBox(width: kDefaultTextSpace),
              Text('Loading', style: TextStyle(fontSize: kDefaultFontSize, color: kDarkGrayColor)),
            ],
          ),
        ),
      ),
    );
  }
}
