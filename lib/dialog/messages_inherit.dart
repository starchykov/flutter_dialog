import 'package:flutter/material.dart';
import 'package:flutter_dialog/models/message_model.dart';

class DataMessageProvider extends InheritedModel<String> {
  final bool loading;
  final List<Message> messages;

  const DataMessageProvider({
    Key? key,
    required this.messages,
    required this.loading,
    required Widget child,
  }) : super(key: key, child: child);

  static DataMessageProvider of(BuildContext context) {
    final DataMessageProvider? result = context.dependOnInheritedWidgetOfExactType<DataMessageProvider>();
    assert(result != null, 'No DataMessageProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DataMessageProvider oldWidget) {
    return messages != oldWidget.messages || loading != oldWidget.loading;
  }

  @override
  bool updateShouldNotifyDependent(covariant DataMessageProvider oldWidget, Set<String> dependencies) {
    final isLoadingUpdate = loading != oldWidget.loading && dependencies.contains('loading');
    final isMessagesUpdate = messages != oldWidget.messages && dependencies.contains('messages');
    return isLoadingUpdate || isMessagesUpdate;
  }
}
