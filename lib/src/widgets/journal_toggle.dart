import 'package:flutter/material.dart';

class JournalToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const JournalToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<bool> isSelected = [!value, value];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ToggleButtons(
        isSelected: isSelected,
        onPressed: (index) => onChanged(index == 1),
        borderRadius: BorderRadius.circular(6),
        constraints: const BoxConstraints(minHeight: 40),
        fillColor: Theme.of(context).primaryColor.withOpacity(0.2),
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Journal',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Discuss',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
