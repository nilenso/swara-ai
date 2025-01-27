import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../../../models/conversation_history.dart';
import '../../../settings/settings_service.dart';
import '../interfaces/transcription_api_interface.dart';

class GeminiTranscriptionAPI implements TranscriptionAPIInterface {
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  final SettingsService _settingsService;

  GeminiTranscriptionAPI(this._settingsService);

  @override
  Future<String> transcribe(String filePath) async {
    final apiKey = await _settingsService.getGeminiKey();
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key not found in settings');
    }

    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final base64Audio = base64Encode(bytes);

    final request = http.Request('POST', Uri.parse('$baseUrl?key=$apiKey'));
    request.headers['Content-Type'] = 'application/json';

    final body = {
      'contents': [
        {
          'parts': [
            {
              'inlineData': {'mimeType': 'audio/mp3', 'data': base64Audio}
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.2,
      },
    };

    request.body = jsonEncode(body);
    final response = await http.Client().send(request);
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 401) {
      throw Exception('Authentication failure');
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to transcribe: ${response.statusCode}');
    }

    final transcriptedText = jsonDecode(responseBody)['candidates'][0]
        ['content']['parts'][0]['text'];

    final box = Hive.box<ConversationHistory>('conversationHistory');
    await box.add(ConversationHistory(
      timestamp: DateTime.now(),
      role: 'user',
      content: transcriptedText,
    ));

    return transcriptedText;
  }
}
