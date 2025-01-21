# Habit Tracker App

<p align="center">
  <img src="https://github.com/sam-baraka/habit_tracker/blob/main/assets/icon/icon.jpeg" width="120" height="120" alt="Habit Tracker Icon" style="border-radius: 20px;">
</p>

A Flutter application for tracking daily habits with gamification features.


## Features Implemented
- ✅ User Authentication
- ✅ Habit Tracking
- ✅ Progress Visualization
- ✅ Offline Functionality
- ✅ Data Synchronization
- ✅ Responsive Design
- ✅ Dark/Light Theme
- ✅ Gamification (XP, Levels, Achievements)

## Local Development Setup

1. **Prerequisites**
   - Flutter SDK (version 3.27.1)
   - Dart SDK
   - Node.js & npm
   - Android Studio / VS Code
   - Git

2. **Clone the Repository**
   ```bash
   git clone https://github.com/sam-baraka/habit_tracker.git
   cd habit_tracker
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Firebase Setup**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli

   # Install Firebase CLI
   npm install -g firebase-tools

   # Login to Firebase
   firebase login

   # Configure Firebase for your Flutter app
   flutterfire configure --project=your-project-id

   # This will:
   # - Create a new Firebase project (or select existing)
   # - Add Android & iOS & Web apps
   # - Download and add config files automatically
   # - Generate firebase_options.dart
   ```

5. **Run the App**
   ```bash
   flutter run
   ```

## Testing

1. **Run Tests**
   ```bash
   flutter test
   ```

2. **Generate Coverage Report**
   ```bash
   flutter test --coverage
   ```

## CI/CD Pipeline

Our CI/CD pipeline is implemented using GitHub Actions and consists of three main jobs:

### 1. Test Job
- Runs on Ubuntu latest
- Sets up Flutter 3.27.1
- Gets dependencies
- Runs tests with coverage
- Uploads coverage report as artifact

### 2. Build Job
- Triggers after successful tests
- Builds web version
- Builds Android APK
- Deploys to Firebase hosting
- Uploads APK as artifact

### 3. Release Job
- Creates GitHub release
- Uploads APK to release
- Automatically versions releases (v1.0.x)

### Pipeline Triggers
- Activates on push to main branch
- Requires following secrets:
  - FIREBASE_TOKEN
  - GTH_TKN (GitHub Token)

## CI/CD Status
[![Flutter CI/CD Pipeline](https://github.com/sam-baraka/habit_tracker/actions/workflows/main.yml/badge.svg)](https://github.com/sam-baraka/habit_tracker/actions/workflows/main.yml)

## Getting Started with Flutter

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
