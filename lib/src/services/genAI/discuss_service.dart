import 'package:hive/hive.dart';
import '../../models/conversation_history.dart';
import '../../settings/settings_service.dart';
import '../genai/interfaces/chat_api_interface.dart';
import '../genai/providers/openai_chat_api.dart';
import '../genai/providers/gemini_chat_api.dart';

class DiscussService {
  static const defaultPrompt =
      'You are a helpful coach and assistant. Be kind and keep your responses short.';
  final SettingsService _settingsService;
  late final ChatAPIInterface _chatService;

  DiscussService(SettingsService settingsService)
      : _settingsService = settingsService {
    _initializeChatService().then((_) {}).catchError((error) {
      print('Failed to initialize chat service: $error');
    });
  }

  Future<void> _initializeChatService() async {
    final provider = await _settingsService.getAIProvider();
    _chatService = switch (provider) {
      AIProvider.openai => OpenAIChatAPI(_settingsService),
      AIProvider.gemini => GeminiChatAPI(_settingsService),
    };
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
