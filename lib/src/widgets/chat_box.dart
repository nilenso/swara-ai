import 'package:flutter/material.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => ChatBoxState();
}

class ChatBoxState extends State<ChatBox> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  static const _initialStory =
      "Once upon a time, in a dense forest, there lived a wise old owl named Oliver. Unlike other owls who slept during the day, Oliver had developed a peculiar habit of watching the forest's daytime activities. Through his observations, he learned about the intricate relationships between different creatures - how squirrels helped plant new trees by forgetting where they buried their acorns, how woodpeckers kept trees healthy by removing harmful insects, and how bees ensured the forest stayed vibrant with their pollination work.\n\nOne particularly hot summer, when the forest faced a severe drought, Oliver noticed something remarkable. The ants, typically busy with their own colony's needs, began creating tiny water channels. They would collect morning dew drops and guide them toward struggling seedlings. This small act of what seemed like kindness helped many young plants survive the harsh season.\n\nOther animals soon noticed this innovative solution. The squirrels began using their tails to sprinkle collected dew on higher branches, while birds started dipping their feathers in nearby streams to shower water on distant plants. The forest had transformed into a community where every creature contributed to its survival.\n\nOliver's daytime observations had revealed a profound truth: the forest wasn't just a collection of trees and animals, but a complex network of beings helping each other thrive. His wisdom grew not from hunting at night like other owls, but from witnessing how cooperation and adaptability could overcome the toughest challenges.";

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
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}
