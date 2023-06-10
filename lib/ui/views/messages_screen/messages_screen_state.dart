import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/models/message_model.dart';

/// Represents the state of the MessagesScreen.
@immutable
class MessagesScreenState {

  /// Constructs a MessagesScreenState object.
  const MessagesScreenState({
    required this.messages,
    required this.loading,
    this.messageText = '',
    this.showStickers = false,
  });
  /// The list of messages.
  final List<Message> messages;

  /// Indicates whether messages are being loaded.
  final bool loading;

  /// The text of the input message.
  final String messageText;

  /// Indicates whether stickers are being shown.
  final bool showStickers;

  /// Creates a new MessagesScreenState object with updated fields.
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
