# Changelog

Все заметные изменения проекта документируются в этом файле.

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.1.0/),
проект следует [Semantic Versioning](https://semver.org/lang/ru/).

## [Unreleased]

### Added
- `.editorconfig` для единого стиля отступов и переносов строк.
- `CONTRIBUTING.md` с правилами оформления коммитов, веток и PR.
- `CHANGELOG.md` (этот файл).

## [0.1.0] — 2026-05-10

### Added — M1 Foundation
- Flutter 3.24.5 / Dart 3.5.4 scaffold для iOS и Android.
- Feature-first архитектура (`features/`, `core/`, `widgets/`).
- Дизайн-токены и тёмная / светлая темы с `AppPalette` ThemeExtension.
- Шрифты Manrope, Inter, Caveat (OFL-1.1) в `assets/fonts/`.
- Виджеты: `PillButton`, `MonogramLogo`, `Marquee`, `AnimatedCounter`,
  `FloatingChip`.
- Экраны: `SplashScreen` (морф-анимация), `OnboardingScreen` (3 страницы
  с parallax и морфящимся page indicator), `HomeScreen` (hero, metrics,
  marquee, категории, SOS-баннер).
- Навигация на `go_router`, state на `flutter_riverpod`, персистенс на
  `shared_preferences`.
- Локализация RU/EN через ARB и `flutter gen-l10n`.
- GitHub Actions CI: формат, анализ, тесты, debug APK.
- `docs/PLAN.md` с разбивкой M2–M8.
