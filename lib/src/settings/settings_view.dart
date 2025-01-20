import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xfff4f2e0), Color(0xffeba7b1)],
          ),
        ),
        child: ListView(
          children: [
            // Checkins Section
            Padding(
              padding: EdgeInsets.all(16.0),
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
                        await controller.addCheckIn(time);
                      }
                    },
                  ),
                ],
              ),
            ),
            ...controller.checkInTimes.asMap().entries.map((entry) {
              final index = entry.key;
              final time = entry.value;
              return ListTile(
                title: Text(time.format(context)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => controller.deleteCheckIn(index),
                ),
              );
            }).toList(),
            // const Divider(),
            // Theme Selection

            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: DropdownButton<ThemeMode>(
            //     value: controller.themeMode,
            //     onChanged: controller.updateThemeMode,
            //     items: const [
            //       DropdownMenuItem(
            //         value: ThemeMode.system,
            //         child: Text('System Theme'),
            //       ),
            //       DropdownMenuItem(
            //         value: ThemeMode.light,
            //         child: Text('Light Theme'),
            //       ),
            //       DropdownMenuItem(
            //         value: ThemeMode.dark,
            //         child: Text('Dark Theme'),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
