
# applicationName_mobile

Mobile app for applicationName

## Getting Started

### Dependencies

Before installing or running the app, ensure you have the following prerequisites:

* Flutter SDK (Latest stable version)
* Dart SDK
* Android Studio or VS Code (with Flutter and Dart plugins)
* Android device/emulator

---

### Installing

1. **Clone the repository:**

  ```bash
  git clone <your-repo-url>
  cd applicationName_mobile
  ```

1. **Get the dependencies:**

  ```bash
  flutter pub get
  ```

1. **(Optional) Clean the build:**

  ```bash
  flutter clean
  flutter pub get
  ```

1. **Ensure flavor configurations are properly set up in:**

   * `android/app/build.gradle`
   * `lib/main_dev.dart`
   * `lib/main_uat.dart`
   * `lib/main_prod.dart`
   * `pubspec.yaml`
   * `.env` files (Make sure the correct base URLs and other environment variables are defined for each flavor)

2. **Set up secure environment variables using `secure_dotenv`:**

   * 📦 [Secure Dotenv Package](https://pub.dev/documentation/secure_dotenv/latest/)

   * **Install dependencies in `pubspec.yaml`:**

     ```yaml
     dependencies:
       secure_dotenv: ^0.1.0
     dev_dependencies:
       build_runner: ^2.4.5
       secure_dotenv_generator: ^0.1.0
     ```

   * **Generate a secure key using:**

     ```bash
     openssl rand -base64 32
     ```

   * **Create a file in project root:** `.env`

   * Example `.env` content:

     ```env
     BASE_U_R_L_DEV= <Add URL Hear>
     BASE_U_R_L_UAT= <Add URL Hear>
     BASE_U_R_L_PROD= <Add URL Hear>
     ```

   * **Build command with encryption key:**

     ```bash
     flutter pub run build_runner build --define "secure_dotenv_generator:secure_dotenv=ENCRYPTION_KEY=Your_Key"
     ```

---

## Executing Program

### Build APKs

Use the following commands to build the APKs for different environments:

```bash
flutter build apk --flavor uat lib/main_uat.dart
flutter build apk --flavor dev lib/main_dev.dart
flutter build apk --flavor prod lib/main_prod.dart
```

### Run App

Use the following commands to run the app on a connected device or emulator:

```bash
flutter run --release --flavor dev -t lib/main_dev.dart
flutter run --release --flavor uat -t lib/main_uat.dart
flutter run --release --flavor prod lib/main_prod.dart
```

---

## Help

If you encounter issues while building or running the app, try the following:

* Run `flutter clean` and then `flutter pub get`
* Check your `build.gradle` for proper flavor definitions
* Ensure `main_dev.dart` , `main_uat.dart` and `main_prod.dart` are correctly set up
* Confirm `.env` files are present with valid `BASE_URL` and other environment variables
* Make sure you're using the correct command for the right flavor

For general Flutter help:

```bash
flutter --help
```

---
