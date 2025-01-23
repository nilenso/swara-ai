import 'package:hive/hive.dart';
import 'package:swara/src/models/conversation_history.dart';
import 'package:swara/src/services/genAI/chat_service.dart';
import 'package:swara/src/settings/settings_service.dart';
import 'package:swara/src/widgets/developer_prompts.dart';

class SummaryService {
  final ChatService _chatService;

  SummaryService(SettingsService settingsService)
      : _chatService = ChatService(settingsService);

  Future<String> getSummary(DateTime start, DateTime end) async {
    final box = Hive.box<ConversationHistory>('conversationHistory');
    final entries = box.values.where((entry) =>
        entry.timestamp.isAfter(start) && entry.timestamp.isBefore(end));

    if (entries.isEmpty) return '';

    final transcriptionsText = entries
        .map((e) => '${e.timestamp.toIso8601String()}: ${e.content}')
        .join('\n');

    return _chatService.chat(
      transcriptionsText,
      developerPrompt: DeveloperPrompts.defaultSummarizerPrompt,
    );
  }
}
