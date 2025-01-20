import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/checkin.dart';

/// A service that stores and retrieves user settings.
const String checkinBoxName = 'checkins';

///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  Future<List<Checkin>> getCheckins() async {
    final box = await Hive.openBox<Checkin>(checkinBoxName);
    final checkins = box.values.toList();
    checkins.sort((a, b) => a.time.compareTo(b.time));
    return checkins;
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  Future<void> addCheckin(Checkin checkin) async {
    final box = await Hive.openBox<Checkin>(checkinBoxName);
    if (box.values.any((c) =>
        c.time.hour == checkin.time.hour &&
        c.time.minute == checkin.time.minute)) {
      throw Exception('You already have a check-in at this time');
    }
    await box.add(checkin);
  }

  Future<void> deleteCheckin(Checkin checkin) async {
    final box = await Hive.openBox<Checkin>(checkinBoxName);
    final entry = box.values.firstWhere(
      (c) =>
          c.time.hour == checkin.time.hour &&
          c.time.minute == checkin.time.minute,
    );
    final key = box.keyAt(box.values.toList().indexOf(entry));
    await box.delete(key);
  }
}
