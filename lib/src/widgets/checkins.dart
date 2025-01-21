import 'package:flutter/material.dart';
import '../settings/settings_controller.dart';

class Checkins extends StatelessWidget {
  const Checkins({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Checkins',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    try {
                      await controller.addCheckin(time, '');
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
        ...controller.checkins.map((checkin) {
          return ListTile(
            dense: true,
            title: Text(
              checkin.time.format(context),
              style: const TextStyle(fontSize: 24),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, size: 24),
              onPressed: () => controller.deleteCheckin(checkin),
            ),
            enableFeedback: true,
            minVerticalPadding: 0,
          );
        }).toList(),
      ],
    );
  }
}
