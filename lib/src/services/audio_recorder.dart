import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swara/src/env.dart';
import 'package:swara/src/services/genai/transcription_service.dart';

class AudioRecorderService {
  final _recorder = AudioRecorder();
  final _transcriptionService = TranscriptionService(apiKey: Env.openaiApiKey);
  bool _isRecording = false;
  String? _currentPath;

  bool get isRecording => _isRecording;

  Future<String?> startRecording() async {
    if (_isRecording || _currentPath != null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String();
    final path = '${appDir.path}/$timestamp.wav';

    if (await _recorder.hasPermission()) {
      try {
        await _recorder.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: path,
        );
        _isRecording = true;
        _currentPath = path;
        return _currentPath;
      } catch (e) {
        _isRecording = false;
        return null;
      }
    }
    return null;
  }

  Future<String?> stopRecording() async {
    if (!_isRecording || _currentPath == null) return null;

    try {
      await _recorder.stop();
      _isRecording = false;

      final transcription =
          await _transcriptionService.transcribe(_currentPath!);
      _currentPath = null;
      return transcription;
    } catch (e) {
      _currentPath = null;
      return null;
    }
  }
}
