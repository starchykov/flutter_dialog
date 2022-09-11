import 'package:flutter_dialog/models/message_model.dart';

class MessagesScreenState {
  final List<Message> messages;
  final bool loading;
  final String messageText;
  final bool showStickers;


  const MessagesScreenState({
    required this.messages,
    required this.loading,
    this.messageText = '',
    this.showStickers = false,
  });

  MessagesScreenState copyWith({
    List<Message>? messages,
    bool? loading,
    String? messageText,
    bool? showStickers,
  }) {
    return MessagesScreenState(
      messages: messages ?? this.messages,
      loading: loading ?? this.loading,
      messageText: messageText ?? this.messageText,
      showStickers: showStickers ?? this.showStickers,
    );
  }
}
