import 'package:flutter/material.dart';

class DebugButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DebugButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.bug_report),
      onPressed: onPressed,
    );
  }
}
