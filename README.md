# KSRCE ERP (Flutter)

## Project Overview

A secure access management system for K.S.R. College of Engineering, built with Flutter. This project is a migration from the original React-based web application.

## Technologies Used

This project is built with:

- **Flutter**: For building a high-performance, cross-platform application from a single codebase.
- **Dart**: The programming language for Flutter.
- **Material 3**: The latest version of Google's design system, used for the UI components.
- **go_router**: For declarative, URL-based navigation.
- **shared_preferences**: For simple local data storage.

## Getting Started

### Prerequisites

- Flutter SDK installed - [Official installation guide](https://docs.flutter.dev/get-started/install)
- An IDE with the Flutter plugin (e.g., VS Code or Android Studio).
- A configured device or emulator to run the app.

### Installation

```sh
# Clone the repository
git clone <YOUR_GIT_URL>

# Navigate to the project directory
cd <YOUR_PROJECT_NAME>

# Get the Flutter packages
flutter pub get

# Run the app
flutter run
```

## Available Scripts (Flutter CLI)

- `flutter run`: Run the application in debug mode.
- `flutter build apk`: Build a release APK for Android.
- `flutter build ios`: Build a release IPA for iOS.
- `flutter test`: Run all the tests in the project.
- `flutter analyze`: Analyze the project's Dart code for errors and warnings.

## Development

The project follows a feature-based architecture:
- **`lib/src/features`**: Contains self-contained feature modules (e.g., `auth`).
- **`lib/src/core`**: Contains shared code like theming, API clients, and common widgets.
- **State Management**: Uses a combination of `StatefulWidget` for local state and service classes for application-level state.
- **Routing**: Handled by the `go_router` package for robust navigation.
