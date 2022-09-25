import 'package:flutter/cupertino.dart';

@immutable
class Message {
  final String userName;
  final String message;
  final int isPending;
  final String creationDate;

  const Message({required this.userName, required this.message, required this.isPending, required this.creationDate});

  factory Message.fromRequest(dynamic message) {
    return Message(
      userName: message['userName'] as String,
      message: message['message'] as String,
      isPending: message['isPending'] as int,
      creationDate: message['creationDate'] as String,
    );
  }
}
