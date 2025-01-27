import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/checkin.dart';

/// A service that stores and retrieves user settings.
const String checkinBoxName = 'checkins';
const String promptsBoxName = 'prompts';
const String authBoxName = 'auth_keys';

enum AIProvider {
  openai,
  gemini,
}

///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  Future<String> getSummarizerPrompt() async {
    final box = await Hive.openBox<String>(promptsBoxName);
    return box.get('summarizer', defaultValue: '') ?? '';
  }

  Future<String> getDiscussPrompt() async {
    final box = await Hive.openBox<String>(promptsBoxName);
    return box.get('discuss', defaultValue: '') ?? '';
  }

  Future<void> updateSummarizerPrompt(String prompt) async {
    final box = await Hive.openBox<String>(promptsBoxName);
    await box.put('summarizer', prompt);
  }

  Future<void> updateDiscussPrompt(String prompt) async {
    final box = await Hive.openBox<String>(promptsBoxName);
    await box.put('discuss', prompt);
  }

  Future<List<Checkin>> getCheckins() async {
    final box = await Hive.openBox<Checkin>(checkinBoxName);
    final checkins = box.values.toList();
    checkins.sort((a, b) {
      if (a.time.hour != b.time.hour) {
        return a.time.hour.compareTo(b.time.hour);
      }
      return a.time.minute.compareTo(b.time.minute);
    });
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

  Future<void> updateCheckin(Checkin oldCheckin, Checkin newCheckin) async {
    final box = await Hive.openBox<Checkin>(checkinBoxName);
    final entry = box.values.firstWhere(
      (c) =>
          c.time.hour == oldCheckin.time.hour &&
          c.time.minute == oldCheckin.time.minute,
    );
    final key = box.keyAt(box.values.toList().indexOf(entry));
    await box.put(key, newCheckin);
  }

  Future<String> getOpenAIKey() async {
    final box = await Hive.openBox<String>(authBoxName);
    return box.get('openai_key', defaultValue: '') ?? '';
  }

  Future<String> getGeminiKey() async {
    final box = await Hive.openBox<String>(authBoxName);
    return box.get('gemini_key', defaultValue: '') ?? '';
  }

  Future<void> updateOpenAIKey(String key) async {
    final box = await Hive.openBox<String>(authBoxName);
    await box.put('openai_key', key);
  }

  Future<void> updateGeminiKey(String key) async {
    final box = await Hive.openBox<String>(authBoxName);
    await box.put('gemini_key', key);
  }

  Future<AIProvider> getAIProvider() async {
    final box = await Hive.openBox<String>(authBoxName);
    final provider =
        box.get('ai_provider', defaultValue: AIProvider.openai.name);
    return AIProvider.values.firstWhere((e) => e.name == provider);
  }

  Future<void> updateAIProvider(AIProvider provider) async {
    final box = await Hive.openBox<String>(authBoxName);
    await box.put('ai_provider', provider.name);
  }
}
