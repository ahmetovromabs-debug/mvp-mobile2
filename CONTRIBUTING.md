# Contributing

Спасибо за интерес к проекту **МВП — Мастер в помощь · Mobile**!
Этот документ описывает базовые правила работы в репозитории.

## Окружение разработки

- **Flutter** 3.24.5 (Dart 3.5.4). Рекомендуется через
  [FVM](https://fvm.app/) или нативная установка с
  [flutter.dev](https://docs.flutter.dev/get-started/install).
- **Xcode** 15+ для iOS, **Android Studio** Hedgehog+ или
  Android SDK 34 для Android.
- **JDK 17** (для Gradle на Android).

Перед первым запуском:

```bash
flutter pub get
flutter gen-l10n
```

## Ветки

- `main` — стабильная ветка, всегда зелёный CI, защищена от прямого
  пуша. Все изменения идут только через PR.
- Рабочие ветки именуются так:
  - feature: `feat/<scope>-<short-desc>` или `devin/<timestamp>-<desc>`,
  - bugfix: `fix/<scope>-<short-desc>`,
  - chore: `chore/<short-desc>`.

## Коммиты

Используем [Conventional Commits](https://www.conventionalcommits.org/ru/v1.0.0/):

```
<type>(<scope>): <короткое описание>

<тело — что и зачем, не «как»>

<footer — BREAKING CHANGE, refs #issue, etc.>
```

Часто используемые `type`:

| Type     | Когда применять |
| -------- | --------------- |
| `feat`   | Новая функциональность |
| `fix`    | Исправление бага |
| `refactor` | Рефакторинг без поведения |
| `perf`   | Оптимизация производительности |
| `style`  | Форматирование / отступы (без логики) |
| `test`   | Только тесты |
| `chore`  | Сборка, CI, зависимости, конфиг |
| `docs`   | Документация |

## Перед PR (локально)

```bash
# 1. Формат
dart format lib test

# 2. Статический анализ (CI запускает с --fatal-infos)
flutter analyze --fatal-infos

# 3. Тесты
flutter test

# 4. (опц.) Debug-сборка
flutter build apk --debug
```

Все четыре шага должны быть зелёными.

## Pull Request

- Заголовок PR следует тому же `feat(scope): ...` формату, что и коммиты.
- В теле PR — что меняется, зачем и как протестировать.
- Если в PR есть новые UI-экраны/анимации — приложите запись или
  скриншоты.
- CI должен быть зелёным до мерджа.

## Дизайн и копирайтинг

- Источник истины для UX/визуала — сайт
  [dist-wtczuair.devinapps.com](https://dist-wtczuair.devinapps.com/).
- **Никаких хардкод-строк** в коде. Все строки добавляются в
  `lib/l10n/app_ru.arb` и `lib/l10n/app_en.arb`.
- **Никаких прямых REST-вызовов** к Bitrix24 / SMS-провайдеру /
  Робокассе с устройства — только через серверный прокси.

## Лицензия

Все вклады принимаются на условиях, изложенных в `LICENSE`.
