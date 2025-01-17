import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => ChatBoxState();
}

class ChatBoxState extends State<ChatBox> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  static const _initialStory = "Whats on your mind today?";
  @override
  void initState() {
    super.initState();
    _controller.text = _initialStory;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void addTranscription(String transcription) {
    setState(() {
      _controller.text = "${_controller.text}\n\n$transcription";
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  void addChatResponse(String response) {
    setState(() {
      _controller.text = "${_controller.text}\n\nSwara: $response";
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.66,
      child: TextField(
        controller: _controller,
        scrollController: _scrollController,
        maxLines: null,
        readOnly: true,
        style: GoogleFonts.ptSans(),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}
