import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../settings/settings_service.dart';
import '../interfaces/chat_api_interface.dart';

class GeminiChatAPI implements ChatAPIInterface {
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  final SettingsService _settingsService;

  GeminiChatAPI(this._settingsService);

  @override
  Future<String> sendChatRequest(
    List<Map<String, String>> context,
    String developerPrompt,
    double temperature,
  ) async {
    final apiKey = await _settingsService.getGeminiKey();
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key not found in settings');
    }

    final request = http.Request('POST', Uri.parse('$baseUrl?key=$apiKey'));
    request.headers['Content-Type'] = 'application/json';

    final messages = [
      {
        'role': 'developer',
        'parts': [
          {'text': developerPrompt}
        ]
      },
      ...context.map((msg) => {
            'role': msg['role'],
            'parts': [
              {'text': msg['content']}
            ]
          }),
    ];

    final body = {
      'contents': messages,
      'generationConfig': {
        'temperature': temperature,
      },
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

    return jsonDecode(responseBody)['candidates'][0]['content']['parts'][0]
        ['text'];
  }
}
