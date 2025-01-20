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
                        // final now = DateTime.now();
                        // final dateTime = DateTime(
                        //   now.year,
                        //   now.month,
                        //   now.day,
                        //   time.hour,
                        //   time.minute,
                        // );
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
