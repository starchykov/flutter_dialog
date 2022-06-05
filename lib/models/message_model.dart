class Message {
  final String userName;
  final String message;
  final int isPending;
  final String creationDate;

  const Message(this.userName, this.message, this.isPending, this.creationDate);

  factory Message.fromRequest(dynamic message) {
    return Message(
      message['userName'] as String,
      message['note'] as String,
      message['isPending'] as int,
      message['creationDate'] as String,
    );
  }
}
