import 'package:flutter/material.dart';

class DebugButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DebugButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: const Text('Summarize', style: TextStyle(fontSize: 12)),
    );
  }
}
