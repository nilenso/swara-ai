import 'package:flutter/material.dart';
import 'package:swara/src/widgets/chat_box.dart';
import 'package:swara/src/widgets/talk_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _chatBoxKey = GlobalKey<ChatBoxState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ChatBox(key: _chatBoxKey),
            Expanded(
              child: TalkButton(
                onTranscription: (text) =>
                    _chatBoxKey.currentState?.addTranscription(text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
