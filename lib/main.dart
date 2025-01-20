import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/app.dart';
import 'src/models/checkin.dart';
import 'src/models/time_of_day_adapter.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart'
    show SettingsService, checkinBoxName;

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Close and delete existing box before registering new adapters
  if (Hive.isBoxOpen(checkinBoxName)) {
    await Hive.box(checkinBoxName).close();
  }

  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(CheckinAdapter());

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
