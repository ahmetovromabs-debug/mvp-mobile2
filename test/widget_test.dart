import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvp_mobile/core/theme/app_theme.dart';
import 'package:mvp_mobile/core/theme/theme_mode_provider.dart';
import 'package:mvp_mobile/features/onboarding/onboarding_seen_provider.dart';
import 'package:mvp_mobile/generated/l10n/app_localizations.dart';
import 'package:mvp_mobile/widgets/animated_counter.dart';
import 'package:mvp_mobile/widgets/floating_chip.dart';
import 'package:mvp_mobile/widgets/marquee.dart';
import 'package:mvp_mobile/widgets/monogram_logo.dart';
import 'package:mvp_mobile/widgets/pill_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _wrap(Widget child, {SharedPreferences? prefs, Locale? locale}) {
  final overrides = <Override>[
    if (prefs != null) sharedPreferencesProvider.overrideWithValue(prefs),
  ];
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.dark(),
      locale: locale ?? const Locale('ru'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Material(child: child),
    ),
  );
}

void main() {
  testWidgets('PillButton renders label and is tappable', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        Center(
          child: PillButton(
            label: 'Заказать',
            onPressed: () => taps++,
          ),
        ),
      ),
    );
    expect(find.text('Заказать'), findsOneWidget);
    await tester.tap(find.text('Заказать'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('AnimatedCounter ramps up to its target', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const Center(
          child: AnimatedCounter(target: 1500, suffix: ' ₽'),
        ),
      ),
    );
    // First frame — value still 0.
    await tester.pump();
    expect(find.text('0 ₽'), findsOneWidget);

    // After full duration — value matches target with thousands separator.
    await tester.pump(const Duration(milliseconds: 1300));
    expect(find.text('1\u00A0500 ₽'), findsOneWidget);
  });

  testWidgets('MonogramLogo paints without errors at progress=1',
      (tester) async {
    await tester.pumpWidget(
      _wrap(const Center(child: MonogramLogo(progress: 1, size: 80))),
    );
    expect(find.byType(MonogramLogo), findsOneWidget);
  });

  testWidgets('FloatingChip animates without throwing', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const Center(
          child: FloatingChip(label: 'Замена розеток'),
        ),
      ),
    );
    expect(find.text('Замена розеток'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Замена розеток'), findsOneWidget);
  });

  testWidgets('Marquee renders items', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SizedBox(
          height: 40,
          width: 320,
          child: Marquee(items: ['А', 'Б', 'В']),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('А'), findsWidgets);
    expect(find.text('Б'), findsWidgets);
  });

  test('OnboardingSeenController persists state via SharedPreferences',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ]);
    addTearDown(container.dispose);

    final initial = await container.read(onboardingSeenProvider.future);
    expect(initial, isFalse);

    await container.read(onboardingSeenProvider.notifier).markSeen();
    expect(container.read(onboardingSeenProvider).value, isTrue);

    // New container reads the persisted value.
    final container2 = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ]);
    addTearDown(container2.dispose);
    expect(await container2.read(onboardingSeenProvider.future), isTrue);
  });

  test('ThemeModeController defaults to dark and toggles', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ]);
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.dark);
    await container.read(themeModeProvider.notifier).toggle();
    expect(container.read(themeModeProvider), ThemeMode.light);
    await container.read(themeModeProvider.notifier).toggle();
    expect(container.read(themeModeProvider), ThemeMode.dark);
  });
}
