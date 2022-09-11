import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/models/message_model.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_state.dart';
import 'package:flutter_dialog/ui/widgets/responsive.dart';

class MessagesScreenViewModel extends ChangeNotifier {
  MessagesScreenState _state = const MessagesScreenState(loading: true, messages: []);

  MessagesScreenState get state => _state;

  final TextEditingController _inputMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  TextEditingController get inputMessageController => _inputMessageController;

  bool get isInputEmpty=> _inputMessageController.text.isEmpty;

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
      const Message('John', 'This is not sent message with long text: text text text text text text', 2, '15.05.2022'),
      const Message('Olexei', 'Hello Hello Hello Hello!', 0, '15.05.2022'),
      const Message('John', 'This is long text message: text text text text text text text text text', 1, '15.05.2022'),
      const Message('John', 'This is example of the Flutter dialog!', 0, '15.05.2022'),
      const Message('John', 'Hello! ', 1, '15.05.2022'),
    ];

    _state = _state.copyWith(loading: false, messages: testDataList);
    notifyListeners();
  }

  Future scrollListener() async {
    ScrollPosition scrollPosition = _scrollController.position;
    if (_scrollController.offset >= scrollPosition.maxScrollExtent && !scrollPosition.outOfRange) {}
    if (_scrollController.offset <= scrollPosition.minScrollExtent && !scrollPosition.outOfRange) {
      await getMessages();
    }
  }

  void onMessageInputPrint({required String messageText}) {
    _state = _state.copyWith(messageText: messageText, showStickers: false);
    notifyListeners();
  }

  Future sendMessage() async {
    Message newMessage = Message('John', _inputMessageController.text, 2, '16.05.2022');
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

  void showStickers () {
    _state = _state.copyWith(showStickers: !_state.showStickers);
    notifyListeners();
  }
}
