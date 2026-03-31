# 📍 Campus Rescue — Lost & Found App

![Status](https://img.shields.io/badge/Status-🟢%20Ongoing%20%2F%20Working%20Currently-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey)

> A modern Flutter application to help students report and recover lost & found items on campus.

---

## 🚦 Project Status

**🟢 Status: Ongoing / Working Currently**

The app is fully functional with local state management. Firebase backend integration is planned for a future release.

---

## ✨ Features

- 🔐 **Login & Register** — Local auth with username, email, phone validation
- 🗂️ **4-Tab Dashboard** — Lost History, Found History, Report Lost, Report Found
- 📸 **Image Picker** — Camera & Gallery support with live preview
- 🏷️ **Category Chips** — Quick item categorization
- 📍 **Location & Phone** — Contact details with country code prefix
- 🔄 **Status Badges** — Dynamic: Searching → Recovered → Handed Over
- ⏱️ **Relative Timestamps** — "2h ago", "Just now" etc.
- 💫 **Animated Bottom Nav** — Active tab expands with label
- 🎨 **Glassmorphism UI** — Deep Teal & Coral design system

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart 3.x |
| State Management | Provider |
| Image Handling | image_picker + File |
| Time Formatting | intl |
| Backend | Local (Firebase integration planned) |

---

## 🚀 Getting Started

```bash
# Clone the repo
git clone https://github.com/Nikhil9367/Campus_Lost_and_Found.git

# Navigate to project
cd Campus_Lost_and_Found

# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run on Android
flutter run -d android
```

**Test Login:** Use any email + password with 6+ characters
> e.g. `student@campus.com` / `123456`

---

## 📁 Project Structure

```
lib/
├── main.dart               # Entry point + Provider setup
├── app_state.dart          # Local state management
├── theme.dart              # Design system (colors, styles)
└── screens/
    ├── login_screen.dart
    ├── register_screen.dart
    ├── home_screen.dart        # Animated bottom nav
    ├── report_form_screen.dart # Image picker + form
    └── history_screen.dart     # Cards with status badges
```

---

## 🗺️ Roadmap

- [x] Local auth & state management
- [x] 4-tab dashboard with animated nav
- [x] Image picker with preview
- [x] Category chips & phone validation
- [x] Status badge cycling
- [ ] Firebase Auth integration
- [ ] Firestore real-time database
- [ ] Push notifications
- [ ] Admin dashboard

---

## 👤 Author

**Nikhil Jangir**
- GitHub: [@Nikhil9367](https://github.com/Nikhil9367)
- Email: nikhiljangir9783@gmail.com
