# МВП — Мастер в помощь · Mobile

Кроссплатформенное приложение (Flutter, iOS + Android) для сервиса
«мастер на час» в Тюмени. Соответствует визуальной системе сайта
[dist-wtczuair.devinapps.com](https://dist-wtczuair.devinapps.com/) и
интегрируется с Bitrix24 CRM через бэкенд-прокси.

> Этот репозиторий пока содержит **M1 «Foundation»** — фундамент проекта.
> M2–M8 (каталог, мастер заказа, Bitrix-интеграция, чат, оплата,
> релиз в сторы) разрабатываются итеративно. См.
> [`docs/PLAN.md`](docs/PLAN.md).

## Что есть в M1

- **Архитектура**: feature-first каталоги (`features/`, `core/`, `widgets/`).
- **Дизайн-система**:
  - Токены цветов, типографики, отступов, радиусов
    (`lib/core/theme/`).
  - Тёмная (основная) и светлая темы с собственным `AppPalette`
    `ThemeExtension`.
  - Шрифты Manrope (display), Inter (body), Caveat (акценты) —
    свободные шрифты `OFL-1.1`, лежат в `assets/fonts/`.
- **Виджеты библиотеки**:
  - `PillButton` с glow-эффектом и хаптикой,
  - `MonogramLogo` (морф точки в «МВП»),
  - `Marquee` — бесконечная лента,
  - `AnimatedCounter` (с русским разделителем тысяч),
  - `FloatingChip` (эллиптическая орбита).
- **Экраны**:
  - `Splash` — морф-анимация + резолв маршрута,
  - `Onboarding` (3 страницы с parallax-эффектом),
  - Скелет `Home` (hero + метрики + marquee + категории + SOS-баннер).
- **Навигация**: `go_router`, маршрутизация на основе флага
  «onboarding seen» из `SharedPreferences`.
- **Локализация**: ARB (RU/EN), `flutter_gen-l10n`.
- **State management**: Riverpod 2.x.
- **CI**: GitHub Actions —
  `dart format`, `flutter analyze --fatal-infos`, `flutter test`,
  `flutter build apk --debug`.

## Стек

| Слой | Технология |
| --- | --- |
| Framework | Flutter 3.24.5 / Dart 3.5.4 |
| State | `flutter_riverpod` 2.x |
| Routing | `go_router` 14.x |
| Animations | `flutter_animate` + `AnimationController` |
| Persistence | `shared_preferences` |
| Networking *(M2+)* | `dio` (с интерсепторами для проксированного Bitrix24) |
| Tests | `flutter_test`, `mocktail` *(в M2+)* |
| Lint | `very_good_analysis` |

## Быстрый старт

```bash
# 1. Установить Flutter 3.24.5 (через FVM или нативно)
flutter --version  # Flutter 3.24.5 • Dart 3.5.4

# 2. Зависимости + локализации
flutter pub get
flutter gen-l10n

# 3. Запуск
flutter run -d ios        # iPhone simulator
flutter run -d emulator-5554  # Android emulator
```

## Структура каталогов

```
lib/
├── core/
│   ├── router/             # go_router, redirect-логика
│   └── theme/              # цвета, типографика, темы, ThemeExtension
├── features/
│   ├── splash/             # экран запуска
│   ├── onboarding/         # 3-страничный onboarding
│   └── home/               # главный экран + его виджеты
├── generated/              # автогенерация l10n (gitignored)
├── l10n/                   # ARB-источники
├── widgets/                # переиспользуемые UI-компоненты
└── main.dart               # точка входа

assets/
├── fonts/                  # Manrope, Inter, Caveat
├── images/                 # *.png, *.svg
└── animations/             # *.json (Lottie, в M3+)

test/
└── widget_test.dart        # smoke + unit-тесты для виджетов
```

## Соглашения

- **Никаких хардкод-строк** в коде: все пользовательские строки идут
  через `AppLocalizations.of(context).<key>` и описаны в
  `lib/l10n/app_ru.arb` / `app_en.arb`.
- **Никаких прямых REST-вызовов** к Bitrix24 / SMS-провайдеру /
  Робокассе с устройства: только через серверный прокси, который будет
  добавлен в M2.
- **Никаких токенов в коде** — секреты только через `--dart-define`
  и GitHub Actions secrets.
- **Никакого WebView** на главные сценарии — приложение нативное.

## Анимации (всего 18 запланировано)

В M1 реализованы 7 из 18:

1. Splash morph (точка → «МВП»).
2. Pulse-dot в hero-плашке «Принимаем 24/7».
3. Hero text reveal (fade + slide).
4. Marquee tape (28 px/sec бесконечная прокрутка).
5. Animated counters в metrics-strip.
6. Floating chips (эллиптическая орбита).
7. Onboarding parallax + морфящийся page indicator.
8. SOS-баннер «дыхание» (pulse border).

Оставшиеся 10–11 (liquid CTA, mesh-gradient, sticky tabs, FAB-rocket,
order step transitions, и т. д.) — в M2–M5.

## Лицензия

См. отдельный файл `LICENSE`. Шрифты — `OFL-1.1`.
