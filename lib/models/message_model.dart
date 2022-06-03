class Message {
  final String userName;
  final String message;
  final int isPending;
  final String creationDate;

  const Message(this.userName, this.message, this.isPending, this.creationDate);

  factory Message.fromRequest(message) {
    return Message(
      message['userName'],
      message['note'],
      message['isPending'],
      message['creationDate'],
    );
  }
}
