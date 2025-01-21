import 'package:flutter/material.dart';
import '../models/checkin.dart';
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
  List<Checkin> _checkins = [];
  String _summarizerPrompt = '';
  String _discussPrompt = '';

  ThemeMode get themeMode => _themeMode;
  List<Checkin> get checkins => List.unmodifiable(_checkins);
  String get summarizerPrompt => _summarizerPrompt;
  String get discussPrompt => _discussPrompt;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _checkins = await _settingsService.getCheckins();
    _summarizerPrompt = await _settingsService.getSummarizerPrompt();
    _discussPrompt = await _settingsService.getDiscussPrompt();
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

  Future<void> addCheckin(TimeOfDay time, String note) async {
    try {
      final checkin = Checkin(time: time, note: note);
      await _settingsService.addCheckin(checkin);
      _checkins = await _settingsService.getCheckins();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCheckin(Checkin checkin) async {
    await _settingsService.deleteCheckin(checkin);
    _checkins = await _settingsService.getCheckins();
    notifyListeners();
  }

  Future<void> updateSummarizerPrompt(String prompt) async {
    _summarizerPrompt = prompt;
    await _settingsService.updateSummarizerPrompt(prompt);
    notifyListeners();
  }

  Future<void> updateDiscussPrompt(String prompt) async {
    _discussPrompt = prompt;
    await _settingsService.updateDiscussPrompt(prompt);
    notifyListeners();
  }
}
