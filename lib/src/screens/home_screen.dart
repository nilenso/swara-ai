import 'package:flutter/material.dart';
import 'package:swara/src/services/genAI/chat_service.dart';
import 'package:swara/src/env.dart';
import 'package:swara/src/widgets/chat_box.dart';
import 'package:swara/src/widgets/talk_button.dart';
import 'package:swara/src/widgets/journal_toggle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _chatBoxKey = GlobalKey<ChatBoxState>();
  final _talkButtonKey = GlobalKey<TalkButtonState>();
  bool _isToggled = false;
  ChatService? _chatService;

  @override
  void initState() {
    super.initState();
    _initChatService();
    WidgetsBinding.instance.addObserver(this);
  }

  void _initChatService() {
    try {
      _chatService = ChatService(apiKey: Env.openaiApiKey);
    } catch (e) {
      debugPrint('Failed to initialize chat service: $e');
    }
  }

  Future<void> _handleTranscription(String text) async {
    _chatBoxKey.currentState?.addTranscription(text);
    if (_isToggled && _chatService != null) {
      try {
        final response = await _chatService!.chat(text);
        _chatBoxKey.currentState?.addChatResponse(response);
      } catch (e) {
        debugPrint('Chat error: $e');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _talkButtonKey.currentState?.stopRecording();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xfff4f2e0), Color(0xffeba7b1)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              JournalToggle(
                value: _isToggled,
                onChanged: (value) => setState(() => _isToggled = value),
              ),
              ChatBox(key: _chatBoxKey),
              Expanded(
                child: TalkButton(
                  key: _talkButtonKey,
                  onTranscription: _handleTranscription,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
