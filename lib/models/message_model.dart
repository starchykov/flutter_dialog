import 'package:flutter/cupertino.dart';

/// Represents a message object.
@immutable
class Message {
  /// Constructs a Message object.
  const Message({
    this.id = -1,
    this.userName = '',
    this.messageText = '',
    this.isPending = 0,
    this.creationDate = '',
  });

  /// Constructs a Message object from a map representation.
  ///
  /// [map] is a map containing the fields of the Message object.
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as int,
      userName: map['userName'] as String,
      messageText: map['message'] as String,
      isPending: map['isPending'] as int,
      creationDate: map['creationDate'] as String,
    );
  }

  /// [id] is the unique identifier for the message.
  final int id;

  /// [userName] is the name of the user who sent the message.
  final String userName;

  /// [messageText] is the content of the message.
  final String messageText;

  /// [isPending] indicates whether the message is pending or not.
  final int isPending;

  /// [creationDate] is the timestamp of when the message was created.
  final String creationDate;

  /// Converts the Message object to a map representation.
  ///
  /// Returns a map containing the fields of the Message object as key-value pairs.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'message': messageText,
      'isPending': isPending,
      'creationDate': creationDate,
    };
  }

  /// Creates a new Message object with updated fields.
  ///
  /// [id] is the new value for the id field.
  /// [userName] is the new value for the userName field.
  /// [messageText] is the new value for the messageText field.
  /// [isPending] is the new value for the isPending field.
  /// [creationDate] is the new value for the creationDate field.
  ///
  /// Returns a new Message object with the updated fields.
  Message copyWith({
    int? id,
    String? userName,
    String? messageText,
    int? isPending,
    String? creationDate,
  }) {
    return Message(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      messageText: messageText ?? this.messageText,
      isPending: isPending ?? this.isPending,
      creationDate: creationDate ?? this.creationDate,
    );
  }
}
