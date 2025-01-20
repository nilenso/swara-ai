import 'package:flutter/material.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;
  List<TimeOfDay> _checkInTimes = [];

  ThemeMode get themeMode => _themeMode;
  List<TimeOfDay> get checkInTimes => List.unmodifiable(_checkInTimes);

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    final times = await _settingsService.checkInTimes();
    _checkInTimes = times.map((t) {
      final parts = t.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> addCheckIn(TimeOfDay time) async {
    _checkInTimes.add(time);
    _checkInTimes
        .sort((a, b) => a.hour * 60 + a.minute - (b.hour * 60 + b.minute));
    notifyListeners();
    await _saveCheckInTimes();
  }

  Future<void> deleteCheckIn(int index) async {
    _checkInTimes.removeAt(index);
    notifyListeners();
    await _saveCheckInTimes();
  }

  Future<void> _saveCheckInTimes() async {
    final times = _checkInTimes
        .map((t) =>
            '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}')
        .toList();
    await _settingsService.updateCheckInTimes(times);
  }
}
