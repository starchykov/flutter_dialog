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
          width: MediaQuery.of(context).size.width * .4,
          margin: const EdgeInsets.all(kBoxMarginDefault),
          padding: const EdgeInsets.all(kTextSpaceDefault),
          decoration: const BoxDecoration(
            color: kTransparencyGrayColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(kBorderRadiusDefault),
              bottomRight: Radius.circular(kBorderRadiusDefault),
              topLeft: Radius.circular(kBorderRadiusDefault),
              topRight: Radius.circular(kBorderRadiusDefault),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CupertinoActivityIndicator(radius: kOffsetDouble),
              const SizedBox(width: kOffsetDouble),
              Text(
                'Loading',
                style: TextStyle(
                  fontSize: kDefaultFontSize,
                  color: CupertinoTheme.of(context).textTheme.textStyle.color?.withOpacity(.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
