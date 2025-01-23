import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../settings/settings_service.dart';

class ChatService {
  final String baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const defaultPrompt =
      'You are a helpful coach and assistant. Be kind and keep your responses short.';
  final SettingsService _settingsService;

  ChatService(this._settingsService);

  Future<String> chat(String input, {String? developerPrompt}) async {
    final apiKey = await _settingsService.getOpenAIKey();
    if (apiKey.isEmpty) {
      throw Exception('OpenAI API key not found in settings');
    }
    final request = http.Request('POST', Uri.parse(baseUrl));

    request.headers['Authorization'] = 'Bearer $apiKey';
    request.headers['Content-Type'] = 'application/json';

    final body = {
      'model': 'gpt-4o-mini',
      'messages': [
        {'role': 'developer', 'content': developerPrompt ?? defaultPrompt},
        {'role': 'user', 'content': input}
      ],
      'temperature': 0.7,
    };

    request.body = jsonEncode(body);
    final response = await http.Client().send(request);
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 401) {
      throw Exception('Authentication failure');
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to get chat response: ${response.reasonPhrase}');
    }

    return jsonDecode(responseBody)['choices'][0]['message']['content'];
  }
}
