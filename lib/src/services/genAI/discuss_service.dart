import 'package:hive/hive.dart';
import '../../models/conversation_history.dart';
import '../../settings/settings_service.dart';
import 'interfaces/chat_api_interface.dart';
import 'providers/openai_chat_api.dart';

class DiscussService {
  static const defaultPrompt =
      'You are a helpful coach and assistant. Be kind and keep your responses short.';
  final SettingsService _settingsService;
  late final ChatAPIInterface _chatService;

  DiscussService(SettingsService settingsService)
      : _settingsService = settingsService {
    _initializeChatService();
  }

  void _initializeChatService() {
    // Currently only OpenAI is implemented
    _chatService = OpenAIChatAPI(_settingsService);
  }

  Future<String> chat(String input) async {
    final prompt = await _settingsService.getDiscussPrompt() ?? defaultPrompt;
    final box = Hive.box<ConversationHistory>('conversationHistory');

    final messages = box.values
        .map((e) => {
              'role': e.role,
              'content': e.content,
            })
        .toList();

    final response = await _chatService.sendChatRequest(
      messages,
      prompt,
      0.7,
    );

    await box.add(ConversationHistory(
      timestamp: DateTime.now(),
      role: 'assistant',
      content: response,
    ));

    return response;
  }
}
