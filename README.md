# Campus Rescue: Lost & Found 🎒

A Flutter mini-project for reporting lost & found items on campus.
Mock authentication (no Firebase needed) + local persistence via `shared_preferences`.

## Features
- Glassmorphism Login / Sign-up
- Home feed with Lost / Found tabs (grid cards)
- Search & filter by category
- Report Item screen with image picker
- Detail view with **Contact Owner** (Email + WhatsApp deep links)
- Profile with "My Posts" management

## Run
```bash
flutter pub get
flutter run
```

## Folder Structure
```
lib/
├── main.dart
├── models/
│   └── item_model.dart
├── providers/
│   ├── auth_provider.dart
│   └── item_provider.dart
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── report_item_screen.dart
│   ├── item_detail_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── glass_card.dart
│   └── item_card.dart
└── utils/
    ├── theme.dart
    └── categories.dart
```

## Architecture
- **Models** → plain Dart data classes (`ItemModel`, `UserModel`)
- **Providers** → `ChangeNotifier`s wired with `provider`
- **Views** → screens consuming providers
- **Widgets** → reusable UI (glass card, item card)

## Notes
- All data is stored locally via `shared_preferences` (JSON-encoded).
- Replace `AuthProvider` & `ItemProvider` with Firebase calls to scale up.
- Image paths are stored as local file paths from `image_picker`.


---
> 🛡️ **Security Status:** Scan Completed ✅ | **Last Audit:** 03-June-2026
