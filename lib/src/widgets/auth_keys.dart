import 'package:flutter/material.dart';
import '../settings/settings_controller.dart';

class AuthKeys extends StatelessWidget {
  const AuthKeys({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Authentication',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'OpenAI Key',
              border: OutlineInputBorder(),
            ),
            onChanged: controller.updateOpenAIKey,
            controller: TextEditingController(text: controller.openAIKey),
          ),
          // const SizedBox(height: 16),
          // TextField(
          //   decoration: const InputDecoration(
          //     labelText: 'Gemini AI Key',
          //     border: OutlineInputBorder(),
          //   ),
          //   onChanged: controller.updateGeminiKey,
          //   controller: TextEditingController(text: controller.geminiKey),
          // ),
        ],
      ),
    );
  }
}
