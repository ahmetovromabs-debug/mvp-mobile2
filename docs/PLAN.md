# MVP — План реализации M1–M8

Источник: исходный промт из сессии Devin (см. описание сайта
[dist-wtczuair.devinapps.com](https://dist-wtczuair.devinapps.com/)).
Общая длительность: ~7–8 недель.

## ✅ M1 — Foundation (текущий PR)

Цель: репозиторий, дизайн-система, темизация, навигация, splash +
onboarding с анимациями. Готовится фундамент для всех следующих фич.

Сделано:

- Структура каталогов `features/`, `core/`, `widgets/`.
- Дизайн-токены (цвета, spacing, радиусы, типографика).
- Тёмная + светлая темы с `AppPalette` ThemeExtension.
- Виджеты: `PillButton`, `Marquee`, `AnimatedCounter`,
  `FloatingChip`, `MonogramLogo`.
- Экраны: Splash, Onboarding (3 страницы с parallax), Home-skeleton
  (hero + metrics + marquee + категории + SOS).
- `go_router` + Riverpod + `flutter_gen-l10n` (RU/EN) +
  `SharedPreferences` (onboarding-seen + theme mode).
- GitHub Actions CI: `dart format`, `flutter analyze --fatal-infos`,
  `flutter test`, `flutter build apk --debug`.

DoD: CI зелёный, экраны рендерятся, тесты проходят.

## 🚧 M2 — Backend gateway + Catalog & Service Detail (1.5–2 недели)

Цель: реальный каталог услуг, экран услуги, базовая интеграция с
бэкендом-прокси.

- Серверный прокси (FastAPI / Node Hono) с эндпоинтами:
  `GET /v1/categories`, `GET /v1/services`, `GET /v1/services/{slug}`,
  `POST /v1/orders` (черновик).
- Прокси подписывает запросы к Bitrix24 webhook-секретом из
  переменных окружения.
- Mobile: `lib/data/api/` слой на `dio` + Riverpod-репозитории.
- Экраны: `CatalogScreen` с разделами «Электрика/Сантехника/Бытовые»,
  `ServiceDetailScreen` с фото, FAQ-аккордеоном, ценой/часом.
- Анимации: shared element transition между карточкой категории и
  detail; sticky-tabs в каталоге; mesh-gradient в hero detail.

DoD: список услуг тянется с прокси; экран услуги показывает реальные
данные; анимации между экранами плавные.

## 🚧 M3 — Order Wizard (1.5 недели)

- 4-шаговый мастер заявки: контакт → объект → задача → подтверждение.
- Валидация форм с реактивными ошибками, `intl_phone_field` для
  телефона +7 (RU) + других.
- Прогресс-бар + step transitions (slide + fade).
- Liquid-CTA, который меняет лейбл в зависимости от шага.
- Сохранение черновика заявки в `SharedPreferences` / `hive`.
- При отправке: `POST /v1/orders` → бэкенд кладёт лид в Bitrix24.

DoD: можно оформить заявку, она появляется в Bitrix24 как лид.

## 🚧 M4 — Auth + Profile + Order Tracking (1 неделя)

- SMS-OTP-логин через SMS.ru (прокси: `POST /v1/auth/send-code`,
  `POST /v1/auth/verify`).
- Локальная сессия (JWT, refresh) с `flutter_secure_storage`.
- Экран профиля (имя, телефон, адрес, история заказов).
- Экран отслеживания статуса заявки (timeline: новая → в работе →
  в пути → выполнена).
- Push-токен FCM/APNs регистрируется на бэкенде.

DoD: пользователь логинится по OTP; видит свои заявки; получает
пуш-уведомление при смене статуса.

## 🚧 M5 — Chat with Master (1 неделя)

- Бэкенд: `GET/POST /v1/orders/{id}/messages`, WebSocket
  `/v1/orders/{id}/chat`.
- Mobile: экран чата с мастером (текст, фото, голосовые).
- Push на новое сообщение.
- Анимации: scroll-to-bottom FAB, typing-indicator (3 dots wave),
  message bubble enter (slide + fade).

DoD: можно переписываться с мастером по конкретной заявке.

## 🚧 M6 — Payment (1 неделя)

- Интеграция с Робокассой через прокси:
  `POST /v1/payments/init` → возвращает payment URL → WebView Cassa →
  callback `POST /v1/payments/webhook` на бэкенд.
- Mobile: экран оплаты, выбор метода (карта, СБП), чек после оплаты.
- Подтверждение `paymentStatus=paid` синхронизируется в Bitrix24.

DoD: можно оплатить заявку, в Bitrix24 сделка переходит в
«Оплачено».

## 🚧 M7 — Polish + Performance (3–4 дня)

- Профилирование: 60 fps на iPhone SE 2 и среднем Android.
- Доводка анимаций: timing, easing, haptics.
- Skeleton-лоадеры для всех асинхронных экранов.
- Pull-to-refresh, error states, empty states.
- Accessibility: семантика, scale font, contrast.
- Dark/Light тема (на mid-Android — авто-fallback в dark).

DoD: Lighthouse-аналог по `flutter analyze --verbose` + ручные
прогоны без джитера; CI с perf-тестами через `golden_toolkit`.

## 🚧 M8 — Store Release (3–4 дня)

- App Store: TestFlight build, иконки, скриншоты, описания (RU/EN),
  privacy nutrition label.
- Google Play: Internal Testing track, ARB-описания, screenshots,
  заполнение data-safety.
- Yandex Maps integration (выбор адреса с геокодером).
- CI релизный workflow: tag `v0.1.0` → build IPA + AAB → upload через
  `fastlane`.

DoD: приложение проходит модерацию и доступно в обоих сторах.

## Что не делаем

- **Не вызываем Bitrix24 REST напрямую с устройства** — только через
  серверный прокси.
- **Не WebView-обёртка сайта** — нативные экраны на Flutter.
- **Не злоупотребляем анимациями там, где они мешают взаимодействию**
  (особенно во время ввода в форму).
- **Не хардкодим тексты** — всё через ARB-локализацию.
- **Не коммитим ключи / токены** — только секреты GitHub / CI.
- **Не используем deprecated пакеты Flutter** — только актуальные.

## Контрольные ссылки

- Сайт-источник дизайна: https://dist-wtczuair.devinapps.com/
- Bitrix24 (M2+): запрашиваем webhook + REST-секрет.
- SMS.ru (M4): запрашиваем API-key.
- Robokassa (M6): запрашиваем merchant + password1/password2.
- FCM/APNs (M4): запрашиваем сертификаты.
- Yandex MapKit (M8): запрашиваем mobile-key.
