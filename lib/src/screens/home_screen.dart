import 'package:flutter/material.dart';
import 'package:swara/src/services/genAI/discuss_service.dart';
import 'package:swara/src/services/genAI/summary_service.dart';
import 'package:swara/src/settings/settings_service.dart';
import 'package:swara/src/widgets/chat_box.dart';
import 'package:swara/src/widgets/talk_button.dart';
import 'package:swara/src/widgets/journal_toggle.dart';
import 'package:swara/src/widgets/debug_button.dart';
import 'package:swara/src/widgets/developer_prompts.dart';

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
  late final DiscussService _discussService;
  late final SummaryService _summaryService;
  final _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _initChatService();
    WidgetsBinding.instance.addObserver(this);
  }

  void _initChatService() {
    _discussService = DiscussService(_settingsService);
    _summaryService = SummaryService(_settingsService);
  }

  Future<void> _handleTranscription(String text) async {
    _chatBoxKey.currentState?.addTranscription(text);
    if (_isToggled) {
      try {
        final response = await _discussService.chat(
          text,
        );
        _chatBoxKey.currentState?.addChatResponse(response);
      } catch (e) {
        debugPrint('Chat error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    JournalToggle(
                      value: _isToggled,
                      onChanged: (value) => setState(() => _isToggled = value),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/settings'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // DebugButton(
              //   onPressed: () async {
              //     try {
              //       final now = DateTime.now();
              //       final summary = await _summaryService.getSummary(
              //         now.subtract(const Duration(hours: 1)),
              //         now,
              //       );
              //       _chatBoxKey.currentState?.addTranscription(summary);
              //     } catch (e) {
              //       debugPrint('Error: $e');
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(
              //           content: Text(e.toString()),
              //           backgroundColor: Colors.red,
              //         ),
              //       );
              //     }
              //   },
              // ),
              ChatBox(key: _chatBoxKey),
              Expanded(
                child: TalkButton(
                  key: _talkButtonKey,
                  onTranscription: _handleTranscription,
                  settingsService: _settingsService,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
