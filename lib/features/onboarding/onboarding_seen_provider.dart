import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_mode_provider.dart';

const _seenKey = 'mvp.onboarding_seen.v1';

class OnboardingSeenController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(_seenKey) ?? false;
  }

  Future<void> markSeen() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_seenKey, true);
    state = const AsyncData(true);
  }
}

final onboardingSeenProvider =
    AsyncNotifierProvider<OnboardingSeenController, bool>(
  OnboardingSeenController.new,
);
