import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../../../models/conversation_history.dart';
import '../../../settings/settings_service.dart';
import '../interfaces/transcription_api_interface.dart';

class OpenAITranscriptionAPI implements TranscriptionAPIInterface {
  final String baseUrl = 'https://api.openai.com/v1/audio/transcriptions';
  final SettingsService _settingsService;

  OpenAITranscriptionAPI(this._settingsService);

  @override
  Future<String> transcribe(String filePath) async {
    final apiKey = await _settingsService.getOpenAIKey();
    if (apiKey.isEmpty) {
      throw Exception('OpenAI API key not found in settings');
    }
    final file = File(filePath);
    final request = http.MultipartRequest('POST', Uri.parse(baseUrl));

    request.headers['Authorization'] = 'Bearer $apiKey';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['model'] = 'whisper-1';
    request.fields['temperature'] = '0.2';
    request.fields['language'] = 'en';

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 401) {
      throw Exception('Authentication failure');
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to transcribe: ${response.statusCode}');
    }

    final transcriptedText = jsonDecode(responseBody)['text'];

    final box = Hive.box<ConversationHistory>('conversationHistory');
    await box.add(ConversationHistory(
      timestamp: DateTime.now(),
      role: 'user',
      content: transcriptedText,
    ));

    return transcriptedText;
  }
}
