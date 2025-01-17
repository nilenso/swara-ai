import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class TranscriptionService {
  final String apiKey;
  final String baseUrl = 'https://api.openai.com/v1/audio/transcriptions';

  TranscriptionService({required this.apiKey});

  Future<String> transcribe(String filePath) async {
    final file = File(filePath);
    final request = http.MultipartRequest('POST', Uri.parse(baseUrl));

    request.headers['Authorization'] = 'Bearer $apiKey';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['model'] = 'whisper-1';
    request.fields['temperature'] = 0.2;

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Failed to transcribe: ${response.statusCode}');
    }

    final transcriptionDir = Directory('${file.parent.path}/transcriptions');
    if (!await transcriptionDir.exists()) {
      await transcriptionDir.create();
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final jsonFile = File('${transcriptionDir.path}/$timestamp.json');
    await jsonFile.writeAsString(responseBody);

    return jsonDecode(responseBody)['text'];
  }
}
