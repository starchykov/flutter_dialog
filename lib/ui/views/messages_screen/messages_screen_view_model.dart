import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog/models/message_model.dart';
import 'package:flutter_dialog/ui/views/messages_screen/messages_screen_state.dart';
import 'package:intl/intl.dart';

/// ViewModel for the Messages Screen.
///
/// This class is responsible for managing the business logic and state of the
/// Messages Screen. It extends the [ChangeNotifier] class, allowing it to
/// notify its listeners when the state changes.
class MessagesScreenViewModel extends ChangeNotifier {
  /// Constructor for the MessagesScreenViewModel class.
  ///
  /// Initializes the view model by calling the [_initialize] method.
  MessagesScreenViewModel() {
    _initialize();
  }

  /// The current state of the Messages Screen.
  ///
  /// This private variable represents the current state of the Messages
  /// Screen. It should be accessed through the [state] getter to provide
  /// external access without exposing the underlying variable directly.
  MessagesScreenState _state = const MessagesScreenState(loading: true, messages: []);

  /// Getter for the current state of the Messages Screen.
  ///
  /// Returns the private variable [_state], representing the current state of
  /// the Messages Screen. This getter allows external access to the state
  /// without directly exposing the underlying private variable.
  MessagesScreenState get state => _state;

  /// The input message controller.
  ///
  /// This private variable represents the TextEditingController used for
  /// handling user input in the Messages Screen. It should be accessed
  /// through the [inputMessageController] getter to provide external access
  /// without directly exposing the underlying variable.
  final TextEditingController _inputMessageController = TextEditingController();

  /// Scroll controller for managing the Messages Screen scroll behavior.
  ///
  /// This private variable [_scrollController] is an instance of ScrollController
  /// used for managing the scroll behavior of the Messages Screen. It allows
  /// scrolling to specific positions and listening to scroll events.
  ///
  /// Note: Make sure to dispose of the scroll controller when it's no longer
  /// needed to prevent memory leaks. You can do this by calling the
  /// [dispose] method.
  final ScrollController _scrollController = ScrollController();

  /// Getter for the input message controller.
  ///
  /// Returns the private variable [_inputMessageController], which is an instance
  /// of TextEditingController. This getter allows external access to the
  /// input message controller without directly exposing the underlying private variable.
  TextEditingController get inputMessageController => _inputMessageController;

  /// Getter for the screen scroll controller.
  ///
  /// Returns the private variable [_scrollController], which is an instance
  /// of ScrollController. This getter allows external access to the
  /// screen scroll controller without directly exposing the underlying private variable.
  ScrollController get scrollController => _scrollController;

  final List<Message> _testDataList = [
    const Message(
      id: 1,
      userName: 'John',
      messageText: 'This is not sent message with long text: text text text text text text',
      isPending: 2,
      creationDate: '15.05.2022',
    ),
    const Message(
      id: 2,
      userName: 'Alexei',
      messageText: 'Hello Hello Hello Hello!',
      creationDate: '15.05.2022',
    ),
    const Message(
      id: 3,
      userName: 'John',
      messageText: 'This is long text message: text text text text text text text text text',
      isPending: 1,
      creationDate: '15.05.2022',
    ),
    const Message(
      id: 4,
      userName: 'John',
      messageText: 'This is example of the Flutter dialog!',
      creationDate: '15.05.2022',
    ),
    const Message(
      id: 5,
      userName: 'John',
      messageText: 'Hello! ',
      isPending: 1,
      creationDate: '15.05.2022',
    ),
  ];

  Future<void> _initialize() async {
    _scrollController.addListener(scrollListener);
    await getMessages();
  }

  /// Retrieves messages.
  ///
  /// This method updates the state to indicate that messages are being loaded,
  /// notifies listeners of the state change, simulates a delay of 1 second,
  /// and then updates the state with the loaded messages and notifies listeners again.
  ///
  /// This method does not return any value.
  Future<void> getMessages() async {
    _state = _state.copyWith(loading: true, messages: _state.messages);
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 1));

    _state = _state.copyWith(loading: false, messages: _testDataList);
    notifyListeners();
  }

  /// Scroll listener for handling scrolling events.
  ///
  /// This method listens to the scroll position using the `_scrollController`.
  /// It checks if the scroll offset is at the maximum scroll extent and not out of range.
  /// If it is, it performs certain actions. Additionally, it checks if the scroll offset
  /// is at the minimum scroll extent and not out of range, and if so, it calls the
  /// `getMessages` method.
  Future<void> scrollListener() async {
    final ScrollPosition scrollPosition = _scrollController.position;
    if (_scrollController.offset >= scrollPosition.maxScrollExtent && !scrollPosition.outOfRange) {}
    if (_scrollController.offset <= scrollPosition.minScrollExtent && !scrollPosition.outOfRange) await getMessages();
  }

  /// Handles the printing of a message input.
  ///
  /// This method updates the state with the provided [messageText] and sets
  /// [showStickers] to `false`. It then notifies the listeners of the state change.
  ///
  /// The [messageText] parameter is required and represents the text of the message
  /// to be printed.
  void onMessageInputPrint({required String messageText}) {
    _state = _state.copyWith(messageText: messageText, showStickers: false);
    notifyListeners();
  }

  /// Sends a message.
  ///
  /// This method checks if the input message is empty. If it is, it returns
  /// without performing any further actions. Otherwise, it creates a new [Message]
  /// instance using the provided information and the current date and time. It then
  /// updates the state by adding the new message to the existing list of messages,
  /// clears the input message controller, and notifies the listeners of the state change.
  Future<void> sendMessage() async {
    if (_inputMessageController.text.isEmpty) return;
    final String date = DateFormat('dd.MM.yyyy hh:m').format(DateTime.now());
    final Message newMessage = Message(userName: 'John', messageText: _state.messageText, isPending: 2, creationDate: date);
    _state = _state.copyWith(loading: false, messages: [newMessage, ..._state.messages]);
    _inputMessageController.clear();
    notifyListeners();
  }

  bool isCurrentUser(String user) => 'John' == user;

  /// Calculates the maximum number of lines for the input message.
  ///
  /// This method calculates the maximum number of lines based on the length
  /// of the input message in the [_inputMessageController]. If the length is
  /// less than or equal to 36 characters, it returns 1. If the length divided by
  /// 40 plus 1 (rounded up) is greater than or equal to 5, it returns 5. Otherwise,
  /// it returns the length divided by 40 plus 1 (rounded up).
  ///
  /// Returns the maximum number of lines for the input message.
  int maxLines() {
    if (_inputMessageController.value.text.length <= 36) return 1;
    if ((_inputMessageController.value.text.length / 40 + 1).round() >= 5) return 5;
    return (_inputMessageController.value.text.length / 40 + 1).round();
  }

  /// Toggles the visibility of stickers.
  ///
  /// This method toggles the visibility of stickers in the state by
  /// negating the value of [showStickers]. It then notifies the listeners of the state change.
  void showStickers() {
    _state = _state.copyWith(showStickers: !_state.showStickers);
    notifyListeners();
  }


  /// Copies a message to the clipboard and triggers a light haptic feedback.
  ///
  /// This method copies the [message] text to the clipboard using the `Clipboard.setData`
  /// method. It then triggers a light haptic feedback using the `HapticFeedback.lightImpact`
  /// method.
  ///
  /// The [message] parameter is required and represents the message to be copied.
  Future<void> copyMessage({required Message message}) async {
    await Clipboard.setData(ClipboardData(text: message.messageText));
    await HapticFeedback.lightImpact();
  }

  /// Deletes a message.
  ///
  /// This method removes the specified [message] from the list of messages
  /// in the state. It creates a new list to hold the updated messages, removes
  /// the specified message from the list, updates the state with the new list,
  /// and notifies the listeners of the state change.
  ///
  /// The [message] parameter is required and represents the message to be deleted.
  void deleteMessage({required Message message}) {
    final List<Message> messages = _state.messages;
    messages.remove(message);
    _state = _state.copyWith(messages: messages);
    notifyListeners();
  }

  @override
  void dispose() {
    _inputMessageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
