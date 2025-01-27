abstract class ChatAPIInterface {
  Future<String> sendChatRequest(
    List<Map<String, String>> context,
    String developerPrompt,
    double temperature,
  );
}
