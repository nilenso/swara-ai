import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:swara/src/services/genAI/chat_service.dart';
import 'package:swara/src/env.dart';

class SummaryService {
  final _chatService = ChatService(apiKey: Env.openaiApiKey);

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

    final transcriptionEntries = <String>[];
    for (final file in files) {
      final timestamp = _getTimestampFromFileName(file.path);
      if (timestamp != null &&
          timestamp.isAfter(start) &&
          timestamp.isBefore(end)) {
        final content = await File(file.path).readAsString();
        transcriptionEntries.add('${timestamp.toIso8601String()}: $content');
      }
    }

    transcriptionEntries.sort();
    final transcriptionsText = transcriptionEntries.join('\n');
    if (transcriptionsText.isEmpty) return '';

    return _chatService.chat(
      transcriptionsText,
      developerPrompt:
          'You are my mental health coach. Given a list of my timesetamped messages, create a concise summary to keep track of key events and patterns as well as my mood. Talk to me in first person, say "you" instead of user. Make sure to end with any tasks or reminders which were mentioned. Use bullet points for just these reminders',
    );
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
