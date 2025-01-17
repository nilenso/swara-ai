import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SummaryService {
  Future<String> getSummary(DateTime start, DateTime end) async {
    final appDir = await getApplicationDocumentsDirectory();
    final transcriptionDir = Directory('${appDir.path}/transcriptions');
    if (!await transcriptionDir.exists()) {
      return '';
    }

    final files = await transcriptionDir
        .list()
        .where((entity) => entity.path.endsWith('.json'))
        .toList();
    files.sort((a, b) => a.path.compareTo(b.path));

    final summaryEntries = <String>[];
    for (final file in files) {
      final timestamp = _getTimestampFromFileName(file.path);
      if (timestamp != null &&
          timestamp.isAfter(start) &&
          timestamp.isBefore(end)) {
        final content = await File(file.path).readAsString();
        summaryEntries.add('${timestamp.toIso8601String()}: $content');
      }
    }

    summaryEntries.sort();
    return summaryEntries.join('\n');
  }

  DateTime? _getTimestampFromFileName(String path) {
    final filename = path.split('/').last.replaceAll('.json', '');
    try {
      return DateTime.parse(filename);
    } catch (e) {
      return null;
    }
  }
}
