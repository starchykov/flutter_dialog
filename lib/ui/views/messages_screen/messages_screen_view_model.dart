import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/models/message_model.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_state.dart';
import 'package:flutter_dialog/ui/widgets/responsive.dart';
import 'package:intl/intl.dart';

class MessagesScreenViewModel extends ChangeNotifier {
  MessagesScreenState _state = const MessagesScreenState(loading: true, messages: []);

  MessagesScreenState get state => _state;

  final TextEditingController _inputMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  TextEditingController get inputMessageController => _inputMessageController;

  bool get isInputEmpty => _inputMessageController.text.isEmpty;

  ScrollController get scrollController => _scrollController;

  MessagesScreenViewModel() {
    initialize();
  }

  void initialize() async {
    _scrollController.addListener((scrollListener));
    await getMessages();
  }

  Future<void> getMessages() async {
    _state = _state.copyWith(loading: true, messages: _state.messages);
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 1));
    List<Message> testDataList = [
      const Message(
        userName: 'John',
        message: 'This is not sent message with long text: text text text text text text',
        isPending: 2,
        creationDate: '15.05.2022',
      ),
      const Message(
        userName: 'Alexei',
        message: 'Hello Hello Hello Hello!',
        isPending: 0,
        creationDate: '15.05.2022',
      ),
      const Message(
        userName: 'John',
        message: 'This is long text message: text text text text text text text text text',
        isPending: 1,
        creationDate: '15.05.2022',
      ),
      const Message(
        userName: 'John',
        message: 'This is example of the Flutter dialog!',
        isPending: 0,
        creationDate: '15.05.2022',
      ),
      const Message(
        userName: 'John',
        message: 'Hello! ',
        isPending: 1,
        creationDate: '15.05.2022',
      ),
    ];

    _state = _state.copyWith(loading: false, messages: testDataList);
    notifyListeners();
  }

  Future scrollListener() async {
    ScrollPosition scrollPosition = _scrollController.position;
    if (_scrollController.offset >= scrollPosition.maxScrollExtent && !scrollPosition.outOfRange) {}
    if (_scrollController.offset <= scrollPosition.minScrollExtent && !scrollPosition.outOfRange) await getMessages();
  }

  void onMessageInputPrint({required String messageText}) {
    _state = _state.copyWith(messageText: messageText, showStickers: false);
    notifyListeners();
  }

  Future sendMessage() async {
    Message newMessage = Message(
      userName: 'John',
      message: _inputMessageController.text,
      isPending: 2,
      creationDate: DateFormat('dd.MM.yyyy hh:m').format(DateTime.now()),
    );
    _state = _state.copyWith(loading: false, messages: [newMessage, ..._state.messages]);
    _inputMessageController.clear();
    notifyListeners();
  }

  bool currentUser(String user) => 'John' == user;

  int maxLines() {
    if (_inputMessageController.value.text.length <= 36) return 1;
    if ((_inputMessageController.value.text.length / 40 + 1).round() >= 5) return 5;
    return (_inputMessageController.value.text.length / 40 + 1).round();
  }

  double length(BuildContext context, String text) {
    double screenWidth = MediaQuery.of(context).size.width;
    double messageWidth;

    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);

    if (isTablet && text.length < 25) return messageWidth = (screenWidth * .15) - 10;
    if (isTablet && text.length > 25 && text.length <= 90) return messageWidth = (text.length * 8).toDouble();
    if (isTablet && text.length >= 90) return messageWidth = (screenWidth * .5) - 10;

    if (isMobile && text.length < 25) return messageWidth = (screenWidth * .37);
    if (isMobile && text.length >= 25 && text.length <= 50) return messageWidth = (text.length * 6).toDouble();
    if (isMobile && text.length >= 50) return messageWidth = (screenWidth * .8) - 10;

    messageWidth = screenWidth * .5;

    return messageWidth;
  }

  void showStickers() {
    _state = _state.copyWith(showStickers: !_state.showStickers);
    notifyListeners();
  }
}
