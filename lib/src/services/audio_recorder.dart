import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderService {
  final _recorder = AudioRecorder();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<String?> startRecording() async {
    if (_isRecording) return null;

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
        return path;
      } catch (e) {
        _isRecording = false;
        return null;
      }
    }
    return null;
  }

  Future<void> stopRecording() async {
    if (!_isRecording) return;

    try {
      await _recorder.stop();
      _isRecording = false;
    } catch (e) {
      // Handle error
    }
  }
}
