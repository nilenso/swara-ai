import 'package:flutter/material.dart';

import '../widgets/checkins.dart';
import '../widgets/developer_prompts.dart';
import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Settings'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          children: [
            Checkins(controller: controller),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DeveloperPrompts(
                onSummarizerPromptChanged: controller.updateSummarizerPrompt,
                onDiscussPromptChanged: controller.updateDiscussPrompt,
                initialSummarizerPrompt: controller.summarizerPrompt,
                initialDiscussPrompt: controller.discussPrompt,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
