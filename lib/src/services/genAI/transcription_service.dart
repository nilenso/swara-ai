import 'package:hive/hive.dart';
import '../../models/conversation_history.dart';
import '../../settings/settings_service.dart';
import 'interfaces/transcription_api_interface.dart';
import 'providers/openai_transcription_api.dart';

class TranscriptionService {
  final SettingsService _settingsService;
  late final TranscriptionAPIInterface _transcriptionService;

  TranscriptionService(SettingsService settingsService)
      : _settingsService = settingsService {
    _initializeTranscriptionService();
  }

  void _initializeTranscriptionService() {
    // Currently only OpenAI is implemented
    _transcriptionService = OpenAITranscriptionAPI(_settingsService);
  }

  Future<String> transcribe(String filePath) async {
    final transcriptedText = await _transcriptionService.transcribe(filePath);

    final box = Hive.box<ConversationHistory>('conversationHistory');
    await box.add(ConversationHistory(
      timestamp: DateTime.now(),
      role: 'user',
      content: transcriptedText,
    ));

    return transcriptedText;
  }
}
