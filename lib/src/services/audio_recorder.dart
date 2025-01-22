import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderService {
  final _recorder = Record();
  bool _isRecording = false;
  String? _currentPath;

  bool get isRecording => _isRecording;

  Future<String?> startRecording() async {
    if (_isRecording || _currentPath != null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String();
    final path = '${appDir.path}/$timestamp.m4a';

    if (await _recorder.hasPermission()) {
      try {
        await _recorder.start(
          path: path,
          encoder: AudioEncoder.aacLc,
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
      final path = _currentPath;
      _currentPath = null;
      return path;
    } catch (e) {
      _currentPath = null;
      return null;
    }
  }
}
