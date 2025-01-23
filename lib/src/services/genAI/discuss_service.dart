import 'package:hive/hive.dart';
import '../../models/conversation_history.dart';
import '../../settings/settings_service.dart';
import 'chat_api.dart';

class DiscussService {
  static const defaultPrompt =
      'You are a helpful coach and assistant. Be kind and keep your responses short.';
  final ChatAPI _chatAPI;
  final SettingsService _settingsService;

  DiscussService(SettingsService settingsService)
      : _settingsService = settingsService,
        _chatAPI = ChatAPI(settingsService);

  Future<String> chat(String input) async {
    final prompt = await _settingsService.getDiscussPrompt() ?? defaultPrompt;
    final response = await _chatAPI.sendChatRequest(
      input,
      prompt,
      0.7,
    );

    final box = Hive.box<ConversationHistory>('conversationHistory');
    await box.add(ConversationHistory(
      timestamp: DateTime.now(),
      role: 'assistant',
      content: response,
    ));

    return response;
  }
}
