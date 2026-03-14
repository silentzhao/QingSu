import 'package:shared_preferences/shared_preferences.dart';

abstract class AppPreferencesStore {
  Future<bool> getHasSeenOnboarding();

  Future<void> setHasSeenOnboarding(bool value);

  Future<Map<String, String>?> getOnboardingPreferenceIds();

  Future<void> setOnboardingPreferenceIds(Map<String, String> value);
}

class SharedPrefsAppPreferencesStore implements AppPreferencesStore {
  const SharedPrefsAppPreferencesStore();

  static const _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const _goalPreferenceKey = 'onboarding_goal_id';
  static const _tastePreferenceKey = 'onboarding_taste_id';
  static const _mealtimePreferenceKey = 'onboarding_mealtime_id';

  @override
  Future<bool> getHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  @override
  Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, value);
  }

  @override
  Future<Map<String, String>?> getOnboardingPreferenceIds() async {
    final prefs = await SharedPreferences.getInstance();
    final goal = prefs.getString(_goalPreferenceKey);
    final taste = prefs.getString(_tastePreferenceKey);
    final mealtime = prefs.getString(_mealtimePreferenceKey);
    if (goal == null || taste == null || mealtime == null) {
      return null;
    }
    return {
      'goal': goal,
      'taste': taste,
      'mealtime': mealtime,
    };
  }

  @override
  Future<void> setOnboardingPreferenceIds(Map<String, String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalPreferenceKey, value['goal'] ?? '');
    await prefs.setString(_tastePreferenceKey, value['taste'] ?? '');
    await prefs.setString(_mealtimePreferenceKey, value['mealtime'] ?? '');
  }
}
