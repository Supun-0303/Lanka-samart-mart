# Lanka Smart Mart - Getting Started Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Installation & Setup](#installation--setup)
3. [Running the Project](#running-the-project)
4. [Project Structure](#project-structure)
5. [Available Commands](#available-commands)
6. [Troubleshooting](#troubleshooting)
7. [Firebase Configuration](#firebase-configuration)
8. [Next Steps](#next-steps)

---

## Prerequisites

### System Requirements
- **Windows 10/11, macOS 10.15+, or Linux**
- **Disk Space**: 3-5 GB minimum
- **RAM**: 4 GB minimum (8 GB recommended)
- **Git**: Latest version

### Required Software
1. **Flutter SDK** (3.0.0 or higher)
2. **Dart SDK** (included with Flutter)
3. **Android Studio** or **Xcode** (for iOS)
4. **Visual Studio Code** or Android Studio
5. **Git**

---

## Installation & Setup

### Step 1: Install Flutter

#### Windows:
1. Download Flutter from https://flutter.dev/docs/get-started/install/windows
2. Extract to a stable location (e.g., `C:\flutter`)
3. Add Flutter to your system PATH:
   - Open **Environment Variables**
   - Add `C:\flutter\bin` to your PATH
4. Run in PowerShell:
   ```powershell
   flutter doctor
   ```

#### macOS/Linux:
```bash
# Clone Flutter repository
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH in ~/.bashrc or ~/.zshrc
export PATH="$PATH:/path/to/flutter/bin"

# Verify installation
flutter doctor
```

### Step 2: Set Up Android Development Environment

#### Option A: Using Android Studio
1. Download Android Studio from https://developer.android.com/studio
2. Install with Android SDK, Android SDK Platform, and Android SDK Build-Tools
3. In Android Studio: **Settings > Languages & Frameworks > Flutter**
   - Set Flutter SDK path to your Flutter installation folder
4. Create a virtual device:
   - Device Manager > Create Virtual Device
   - Choose Pixel 6 or similar
   - Select API level 31 or higher

#### Option B: Using Command Line
```powershell
# Install Android SDK
flutter config --android-sdk=C:\Android\sdk

# Accept Android SDK licenses
flutter doctor --android-licenses

# Create emulator
flutter emulators --create --name pixel_6
```

### Step 3: Clone & Set Up Project

```powershell
# Navigate to project directory
cd "c:\Degree\LankaSmartMart beta\lankasmartmart_flutter"

# Get all dependencies
flutter pub get

# Verify setup
flutter doctor
```

---

## Running the Project

### Start the Emulator (or Connect Device)

```powershell
# Option 1: List available devices
flutter devices

# Option 2: Start Android Emulator
flutter emulators --launch pixel_6

# Option 3: Connect physical Android device
# Enable USB debugging in Settings > Developer Options > USB Debugging
adb devices
```

### Run the App

```powershell
# Basic run
flutter run

# Run with verbose output (for debugging)
flutter run -v

# Run in release mode (optimized)
flutter run --release

# Run on specific device
flutter run -d pixel_6
```

### Expected Startup Sequence
1. Compiling Dart code
2. Building APK/app bundle
3. Installing on device/emulator
4. Running app
5. **Loading Screen** appears (2-3 seconds)
6. **Login Screen** displays

---

## Project Structure

```
lib/
├── main.dart                 # Entry point of the application
├── models/                   # Data models
│   ├── product_models.dart   # Product, Category, Review, Promotion
│   ├── user_models.dart      # User, Address, PaymentCard
│   └── order_models.dart     # Order, OrderItem, OrderStatus
├── providers/                # Riverpod state management
│   ├── auth_provider.dart    # Authentication state
│   ├── cart_provider.dart    # Shopping cart state
│   ├── product_provider.dart # Products & categories
│   ├── order_provider.dart   # Orders management
│   ├── address_provider.dart # Saved addresses
│   ├── favorite_provider.dart# Wishlist/favorites
│   └── router_provider.dart  # GoRouter configuration
├── screens/                  # UI screens (30 total)
│   ├── loading_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── product_details_screen.dart
│   ├── checkout_screen.dart
│   ├── order_history_screen.dart
│   ├── profile_screen.dart
│   └── ... (24 more screens)
├── widgets/                  # Reusable widgets
│   └── product_card.dart     # Product card component
├── utils/                    # Utility functions
│   ├── ui_utils.dart         # UI helpers & mock data
│   ├── shake_detector.dart   # Gesture detection
│   ├── location_helper.dart  # Location services
│   └── voice_assistant.dart  # Voice features (optional)
├── theme/                    # App theming
│   └── app_theme.dart        # Material 3 theme, colors, typography
├── services/                 # External services (Firebase, APIs)
└── pubspec.yaml              # Dependencies configuration
```

---

## Available Commands

### Development Commands
```powershell
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated

# Analyze code for issues
flutter analyze

# Format code (Dart style)
dart format lib/

# Run code generation (if needed)
flutter pub run build_runner build
```

### Build Commands
```powershell
# Android APK
flutter build apk

# Android App Bundle (for Play Store)
flutter build appbundle

# iOS app (macOS only)
flutter build ios

# Web (if enabled)
flutter build web
```

### Testing Commands
```powershell
# Run all tests
flutter test

# Run specific test file
flutter test test/providers/auth_provider_test.dart

# Run with coverage
flutter test --coverage
```

### Hot Reload & Hot Restart
```powershell
# During flutter run, press:
# 'r' - Hot reload (changes code only, keeps app state)
# 'R' - Hot restart (full restart, resets app state)
# 'q' - Quit
```

---

## Troubleshooting

### Issue: "Flutter command not found"
**Solution:**
```powershell
# Verify Flutter installation
flutter --version

# Add to PATH if needed
$env:PATH += ";C:\flutter\bin"

# Make permanent by adding to Environment Variables
```

### Issue: "No devices available"
**Solution:**
```powershell
# Check connected devices
flutter devices

# Start emulator manually
flutter emulators --launch pixel_6

# If still not showing, try:
adb kill-server
adb start-server
flutter devices
```

### Issue: "Android SDK not found"
**Solution:**
```powershell
# Set Android SDK path
flutter config --android-sdk=C:\Android\sdk

# Accept licenses
flutter doctor --android-licenses
```

### Issue: "Gradle build failed"
**Solution:**
```powershell
# Clean build
flutter clean

# Get dependencies again
flutter pub get

# Try building again
flutter run

# If persistent, check gradle.properties and build.gradle
```

### Issue: "Compilation errors"
**Solution:**
```powershell
# Update pubspec.yaml dependencies
flutter pub get

# Analyze code
flutter analyze

# Check for specific errors
flutter run -v
```

### Issue: "MissingPluginException"
**Solution:**
```powershell
# Clean everything
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter run

# If still failing, uninstall from device:
adb uninstall com.lankasmartmart.lankasmartmart_flutter
flutter run
```

---

## Firebase Configuration

### Setup Firebase Project
1. Go to https://console.firebase.google.com
2. Create a new project or select existing one
3. Enable these services:
   - Authentication (Email/Password, Google Sign-In)
   - Firestore Database
   - Storage (for images)
   - Functions (optional, for backend logic)

### Android Configuration
1. Download `google-services.json` from Firebase Console
2. Place in: `android/app/google-services.json`
3. Verify in `android/build.gradle`:
   ```gradle
   dependencies {
     classpath 'com.google.gms:google-services:4.3.15'
   }
   ```
4. Verify in `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

### iOS Configuration
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place in: `ios/Runner/GoogleService-Info.plist`
3. Add to Xcode:
   - Open `ios/Runner.xcworkspace`
   - Drag `GoogleService-Info.plist` to Runner
   - Make sure it's added to target

### Initialize Firebase in Code
Update `lib/main.dart`:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: LankaSmartMartApp()));
}
```

---

## Next Steps

### 1. Replace Mock Data with Firebase
- Update `providers/product_provider.dart` to fetch from Firestore
- Connect `providers/auth_provider.dart` to Firebase Auth
- Implement real-time updates using StreamProvider

### 2. Add Firebase Cloud Functions
- Create backend functions for:
  - Order processing
  - Payment verification
  - Notification sending
  - Analytics

### 3. Implement Payment Integration
- Add Stripe/PayPal integration
- Implement card tokenization
- Add payment verification

### 4. Enhance Features
- Add push notifications (Firebase Cloud Messaging)
- Implement chat with real-time Firestore listeners
- Add image upload to Cloudinary
- Implement order tracking with WebSockets

### 5. Testing & Quality
- Write unit tests for providers
- Write widget tests for screens
- Add integration tests
- Set up CI/CD with GitHub Actions

### 6. Deployment
- Build and test release APK
- Set up Google Play Console
- Upload to Play Store
- Set up iOS TestFlight (if developing for iOS)

### 7. Performance Optimization
- Profile app performance using DevTools
- Optimize image loading and caching
- Implement lazy loading for lists
- Monitor app size and reduce bloat

---

## Quick Reference

### Essential Commands
```powershell
# Clone/Setup
cd "c:\Degree\LankaSmartMart beta\lankasmartmart_flutter"
flutter pub get

# Run
flutter run

# Build
flutter build apk

# Clean
flutter clean

# Analyze
flutter analyze
```

### File Locations
- **Main Entry**: `lib/main.dart`
- **Providers**: `lib/providers/`
- **Screens**: `lib/screens/`
- **Models**: `lib/models/`
- **Theme**: `lib/theme/app_theme.dart`
- **Dependencies**: `pubspec.yaml`
- **Android Config**: `android/app/build.gradle`

### Firebase Services
- **Auth**: `firebase_auth` package
- **Firestore**: `cloud_firestore` package
- **Storage**: `firebase_storage` package
- **Functions**: Call via HTTP from Dart code

---

## Need Help?

### Documentation Links
- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Firebase Flutter: https://firebase.flutter.dev
- Riverpod Docs: https://riverpod.dev
- GoRouter Docs: https://pub.dev/packages/go_router

### Common Issues
- Check `flutter doctor` output for missing dependencies
- Review terminal output for specific error messages
- Check device/emulator has sufficient storage (>5GB)
- Ensure internet connection for first build (downloads packages)

---

## Project Status Summary

✅ **Completed**
- All 30 screens implemented
- 7 Riverpod providers configured
- 4 data models with proper structure
- Material 3 theme system
- GoRouter navigation
- All dependencies configured
- Mock data for demo

🔄 **Next Priority**
- Firebase integration
- Real data connectivity
- Payment processing
- Push notifications

---

**Last Updated**: May 2, 2026  
**Flutter Version Required**: ≥3.0.0  
**Dart Version Required**: ≥2.18.0
