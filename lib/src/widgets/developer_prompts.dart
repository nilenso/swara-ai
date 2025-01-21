import 'package:flutter/material.dart';

class DeveloperPrompts extends StatefulWidget {
  final void Function(String)? onSummarizerPromptChanged;
  final void Function(String)? onDiscussPromptChanged;
  final String initialSummarizerPrompt;
  final String initialDiscussPrompt;

  const DeveloperPrompts({
    super.key,
    this.onSummarizerPromptChanged,
    this.onDiscussPromptChanged,
    required this.initialSummarizerPrompt,
    required this.initialDiscussPrompt,
  });

  static const defaultSummarizerPrompt =
      'You are my mental health coach. Given a list of my timestamped messages, create a concise summary to keep track of key events and patterns as well as my mood. Talk to me in first person, say "you" instead of user. Make sure to end with any tasks or reminders which were mentioned. Use bullet points for just these reminders';
  static const defaultDiscussPrompt =
      'You are a helpful coach and assistant. Be kind and keep your responses short.';

  @override
  State<DeveloperPrompts> createState() => _DeveloperPromptsState();
}

class _DeveloperPromptsState extends State<DeveloperPrompts> {
  late final TextEditingController summarizerPromptController;
  late final TextEditingController discussPromptController;

  @override
  void initState() {
    super.initState();
    summarizerPromptController = TextEditingController(
        text: widget.initialSummarizerPrompt.isEmpty
            ? DeveloperPrompts.defaultSummarizerPrompt
            : widget.initialSummarizerPrompt);
    discussPromptController = TextEditingController(
        text: widget.initialDiscussPrompt.isEmpty
            ? DeveloperPrompts.defaultDiscussPrompt
            : widget.initialDiscussPrompt);
  }

  @override
  void dispose() {
    summarizerPromptController.dispose();
    discussPromptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Developer Prompts', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          style: const TextStyle(fontSize: 14),
          controller: summarizerPromptController,
          decoration: const InputDecoration(
            labelText: 'Summarizer Prompt',
            border: OutlineInputBorder(),
          ),
          maxLines: 7,
          minLines: 2,
          onChanged: widget.onSummarizerPromptChanged,
        ),
        const SizedBox(height: 16),
        TextField(
          style: const TextStyle(fontSize: 14),
          controller: discussPromptController,
          decoration: const InputDecoration(
            labelText: 'Discuss Prompt',
            border: OutlineInputBorder(),
          ),
          maxLines: 7,
          minLines: 2,
          onChanged: widget.onDiscussPromptChanged,
        ),
      ],
    );
  }
}
