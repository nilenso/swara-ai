import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderService {
  final _recorder = AudioRecorder();

  Future<String?> startRecording() async {
    final appDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String();
    final path = '${appDir.path}/$timestamp.opus';

    if (await _recorder.hasPermission()) {
      try {
        await _recorder.start(const RecordConfig(), path: path);
        return path;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> stopRecording() async {
    try {
      await _recorder.stop();
    } catch (e) {
      // Handle error
    }
  }
}
