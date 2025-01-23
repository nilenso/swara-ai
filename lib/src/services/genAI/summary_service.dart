import 'package:hive/hive.dart';
import 'package:swara/src/models/conversation_history.dart';
import 'package:swara/src/services/genAI/chat_api.dart';
import 'package:swara/src/settings/settings_service.dart';
import 'package:swara/src/widgets/developer_prompts.dart';

class SummaryService {
  final ChatAPI _chatAPI;

  SummaryService(SettingsService settingsService)
      : _chatAPI = ChatAPI(settingsService);

  Future<String> getSummary(DateTime start, DateTime end) async {
    final box = Hive.box<ConversationHistory>('conversationHistory');
    final entries = box.values.where((entry) =>
        entry.timestamp.isAfter(start) && entry.timestamp.isBefore(end));

    if (entries.isEmpty) return '';

    final messages = entries
        .map((e) => {
              'role': e.role,
              'content': e.content,
            })
        .toList();

    return _chatAPI.sendChatRequest(
      messages,
      DeveloperPrompts.defaultSummarizerPrompt,
      0.7,
    );
  }
}
