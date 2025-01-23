import 'package:hive/hive.dart';

part 'conversation_history.g.dart';

@HiveType(typeId: 2)
class ConversationHistory {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final String role;

  @HiveField(2)
  final String content;

  ConversationHistory({
    required this.timestamp,
    required this.role,
    required this.content,
  });
}
