# FLUTTER SETUP GUIDE - Lanka Smart Mart

## Prerequisites

Before you begin, make sure you have:

1. **Flutter SDK** (v3.0 or higher)
   - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Run `flutter doctor` to verify installation

2. **Dart SDK** (included with Flutter)

3. **IDE**
   - Android Studio with Flutter plugin, OR
   - VS Code with Flutter extension

4. **Devices/Emulators**
   - Android emulator or physical device
   - iOS simulator or physical device (Mac required)

## Installation Steps

### 1. Clone/Navigate to Project
```bash
cd lankasmartmart_flutter
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### For Android:
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or select existing one
3. Register Android app with package name `com.example.lankasmartmart_flutter`
4. Download `google-services.json`
5. Place it in `android/app/google-services.json`

#### For iOS:
1. Register iOS app in Firebase Console
2. Download `GoogleService-Info.plist`
3. Open `ios/Runner.xcworkspace` in Xcode
4. Add the plist file to Xcode project

### 4. Configure Local Properties (Android)

Create `android/local.properties`:
```properties
sdk.dir=/path/to/android/sdk
flutter.sdk=/path/to/flutter
flutter.buildMode=debug
flutter.versionName=1.0.0
flutter.versionCode=1
```

### 5. Update Firebase Config

Edit `lib/utils/constants.dart`:
```dart
static const String googleSignInClientId = 'YOUR_ACTUAL_CLIENT_ID';
static const String cloudinaryCloudName = 'YOUR_CLOUD_NAME';
```

### 6. Build & Run

#### For Android:
```bash
# Debug build
flutter run -d android

# Release build
flutter build apk --release

# App Bundle for Play Store
flutter build appbundle --release
```

#### For iOS:
```bash
# Debug build
flutter run -d ios

# Release build
flutter build ios --release
```

#### For Web (experimental):
```bash
flutter run -d web
```

## Project Configuration

### Pubspec.yaml
The `pubspec.yaml` contains all dependencies. Key packages:

- **flutter_riverpod** - State management
- **go_router** - Navigation
- **firebase_core** - Firebase initialization
- **firebase_auth** - Authentication
- **cloud_firestore** - Database
- **cached_network_image** - Image caching
- **google_fonts** - Typography

### App Structure

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
├── providers/                # Riverpod state management
├── screens/                  # UI screens
├── widgets/                  # Reusable widgets
├── theme/                    # Theme configuration
├── services/                 # Backend services
└── utils/                    # Utilities and constants
```

## Development Workflow

### Hot Reload
```bash
# During flutter run, press 'r' in terminal to hot reload
# Press 'R' for full rebuild
```

### Code Style
```bash
# Format code
flutter format lib/

# Run linter
flutter analyze

# Fix common issues
dart fix --apply
```

### Testing
```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/models/
```

## Common Commands

```bash
# List connected devices
flutter devices

# Create new Flutter app
flutter create app_name

# Upgrade Flutter
flutter upgrade

# Check Flutter environment
flutter doctor -v

# Clean build
flutter clean

# Get latest packages
flutter pub get

# Update packages
flutter pub upgrade
```

## Debugging

### Debug Mode
```bash
# Run in debug mode (default)
flutter run
```

### Release Mode
```bash
flutter run --release
```

### Profile Mode
```bash
flutter run --profile
```

### Verbose Logging
```bash
flutter run -v
```

### Chrome DevTools
```bash
flutter run -d chrome
# Open DevTools from terminal URL
```

## Firebase Emulator (Local Testing)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Start emulator
firebase emulators:start

# In another terminal
flutter run
```

## Performance Optimization

1. **Enable Profiling**
   ```bash
   flutter run --profile
   ```

2. **Check Performance**
   - Use Flutter DevTools: `flutter pub global run devtools`
   - Analyze build size: `flutter build apk --analyze-size`

3. **Reduce App Size**
   ```bash
   flutter build apk --split-per-abi
   ```

## Troubleshooting

### Issue: "flutter: command not found"
**Solution**: Add Flutter bin to PATH
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### Issue: Gradle build fails
**Solution**: 
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Pod install fails (iOS)
**Solution**:
```bash
cd ios
rm Podfile.lock
pod repo update
pod install
cd ..
```

### Issue: Firebase connection errors
**Solution**:
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are added
- Check Firebase project settings
- Verify internet connectivity

## Deployment Checklist

- [ ] Set up Firebase project and credentials
- [ ] Configure signing certificates (Android/iOS)
- [ ] Update app version and build number
- [ ] Test thoroughly on real devices
- [ ] Optimize app size and performance
- [ ] Configure app signing
- [ ] Generate release builds
- [ ] Create app store listings
- [ ] Submit for review
- [ ] Monitor analytics post-launch

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Firebase Flutter Setup](https://firebase.flutter.dev)
- [Riverpod Documentation](https://riverpod.dev)
- [Go Router Package](https://pub.dev/packages/go_router)

## Support

For issues:
1. Check Flutter [FAQ](https://flutter.dev/docs/resources/faq)
2. Search [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter) with `flutter` tag
3. File issue on [Flutter GitHub](https://github.com/flutter/flutter/issues)

---

**Happy Coding! 🚀**
