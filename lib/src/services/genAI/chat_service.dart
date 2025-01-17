import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String apiKey;
  final String baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const defaultPrompt =
      'You are a helpful coach and assistant. Be kind and keep your responses short.';

  ChatService({required this.apiKey});

  Future<String> chat(String input, {String? developerPrompt}) async {
    final request = http.Request('POST', Uri.parse(baseUrl));

    request.headers['Authorization'] = 'Bearer $apiKey';
    request.headers['Content-Type'] = 'application/json';

    final body = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'developer', 'content': developerPrompt ?? defaultPrompt},
        {'role': 'user', 'content': input}
      ],
      'temperature': 0.7,
    };

    request.body = jsonEncode(body);
    final response = await http.Client().send(request);
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Failed to get chat response: ${response.statusCode}');
    }

    return jsonDecode(responseBody)['choices'][0]['message']['content'];
  }
}
