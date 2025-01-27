import 'package:flutter/material.dart';
import '../settings/settings_controller.dart';

class Checkins extends StatefulWidget {
  const Checkins({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  State<Checkins> createState() => _CheckinsState();
}

class _CheckinsState extends State<Checkins> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        ...widget.controller.checkins
            .map((checkin) => _buildCheckinItem(context, checkin))
            .toList(),
      ],
    );
  }

  // Header section with "Checkins" title and Add button
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Checkins',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _handleAddCheckin(context),
          ),
        ],
      ),
    );
  }

  // Individual check-in item
  Widget _buildCheckinItem(BuildContext context, dynamic checkin) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                checkin.time.format(context),
                style: const TextStyle(fontSize: 24),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 24),
                onPressed: () {
                  _controllers.remove(checkin.time.format(context));
                  widget.controller.deleteCheckin(checkin);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 8.0, 0.0),
            child: TextField(
              controller: _controllers.putIfAbsent(
                checkin.time.format(context),
                () => TextEditingController(text: checkin.prompt),
              ),
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Prompt',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              onChanged: (value) =>
                  widget.controller.updatePrompt(checkin, value),
            ),
          ),
        ],
      ),
    );
  }

  // Handle the Add button logic
  Future<void> _handleAddCheckin(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      try {
        await widget.controller.addCheckin(time, 'Hello!');
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }
}
