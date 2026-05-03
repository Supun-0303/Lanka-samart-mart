# Lanka Smart Mart - Flutter Mobile App

A complete Flutter conversion of the Android/Kotlin Lanka Smart Mart e-commerce application. Local shopping and delivery platform built with **Flutter**, **Riverpod**, **GoRouter**, and **Firebase**.

## 🚀 Quick Start

```bash
# 1. Get dependencies
flutter pub get

# 2. Start emulator or connect device
flutter devices
flutter emulators --launch pixel_6

# 3. Run the app
flutter run

# 4. Navigate to Login screen and explore!
```

**📖 For detailed setup instructions, see [GETTING_STARTED.md](GETTING_STARTED.md)**

---

## 📋 Project Structure

```
lib/
  ├── main.dart                 # Entry point
  ├── models/                   # Data models
  │   ├── product_models.dart
  │   ├── user_models.dart
  │   └── order_models.dart
  ├── providers/                # Riverpod state management
  │   ├── auth_provider.dart
  │   ├── cart_provider.dart
  │   ├── product_provider.dart
  │   └── router_provider.dart
  ├── screens/                  # UI Screens
  │   ├── login_screen.dart
  │   ├── home_screen.dart
  │   ├── cart_screen.dart
  │   └── ...
  ├── widgets/                  # Reusable widgets
  │   ├── product_card.dart
  │   └── ...
  ├── theme/                    # Theme configuration
  │   └── app_theme.dart
  ├── services/                 # Services (Firebase, API)
  └── utils/                    # Utilities
```

## ⚙️ Setup & Installation

**📌 Complete setup guide available in [GETTING_STARTED.md](GETTING_STARTED.md)**

### Prerequisites
- Flutter SDK (≥3.0.0)
- Dart SDK (≥2.18.0)
- Android Studio or Xcode
- Git
- Firebase account (optional for demo mode)

### Quick Setup

```bash
# 1. Clone/navigate to project
cd "c:\Degree\LankaSmartMart beta\lankasmartmart_flutter"

# 2. Get all dependencies
flutter pub get

# 3. Check environment
flutter doctor

# 4. Start emulator (choose one)
flutter emulators --launch pixel_6      # Android
# OR connect physical device

# 5. Run app
flutter run

# 6. (Optional) Run with verbose output for debugging
flutter run -v
```

### Firebase Configuration (Optional)
For production use:
1. Create Firebase project at https://console.firebase.google.com
2. Download `google-services.json` → place in `android/app/`
3. Update `lib/main.dart` to initialize Firebase
4. Configure Firestore database rules

**See [GETTING_STARTED.md](GETTING_STARTED.md) for detailed Firebase setup**

## ✨ Key Features

### 📱 User Experience
- **30 screens** fully implemented and integrated
- Material 3 design system with custom theming
- Responsive layouts for all device sizes
- Smooth navigation with GoRouter

### 🔐 Authentication
- Email/Password login
- Google Sign-In integration
- Session management
- User profile management
- Address management
- Saved payment methods

### 🛍️ Shopping Features
- Browse products by category
- Search and filtering capabilities
- Product details with reviews and ratings
- Add items to cart
- Cart management (add, remove, update quantity)
- Wishlist/Favorites
- Promotions and discounts

### 🛒 Checkout & Orders
- Multi-step checkout process
- Address selection and management
- Payment method selection
- Order confirmation
- Order history and tracking
- Order details view

### 💬 Additional Features
- Chat assistant interface
- Help & support section
- Settings and preferences
- Order tracking with timeline
- Shake gesture detection (device shake to access features)
- Location services integration

### 🔧 Technical Stack
- **State Management**: Riverpod (StateNotifierProvider)
- **Navigation**: GoRouter with named routes
- **Backend**: Firebase (Auth, Firestore, Storage)
- **UI Framework**: Flutter with Material 3
- **Local Storage**: Hive + SharedPreferences
- **Image Handling**: Cached Network Image
- **Location**: Geolocator package
- **Sensors**: Sensors Plus (accelerometer)

## 🔄 Migration from Kotlin/Compose

Complete conversion of Android app to Flutter:

| Aspect | Kotlin/Compose | Flutter/Dart |
|--------|---|---|
| **UI Framework** | Jetpack Compose | Flutter Widgets |
| **State Management** | ViewModel + StateFlow | Riverpod StateNotifierProvider |
| **Navigation** | Sealed class + Compose Navigation | GoRouter |
| **Database** | Room + SQLite | Hive + SharedPreferences |
| **Image Loading** | Coil | cached_network_image |
| **HTTP Requests** | Retrofit/OkHttp | http/dio package |
| **Local Storage** | DataStore/SharedPreferences | SharedPreferences + Hive |
| **Sensors** | Android Shake Detector | sensors_plus package |
| **Location** | Android Location API | geolocator package |
| **Authentication** | Firebase Auth | firebase_auth package |
| **Database (Backend)** | Firestore | cloud_firestore package |

### File Conversion Mapping

**Models** (3 files → 3 files)
- `ProductModel.kt` → `product_models.dart`
- `UserModel.kt` → `user_models.dart`
- `OrderModel.kt` → `order_models.dart`

**Providers/ViewModels** (4 files → 7 providers)
- `AuthViewModel.kt` → `auth_provider.dart`
- `ShopViewModel.kt` → `product_provider.dart`, `cart_provider.dart`
- `OrderViewModel.kt` → `order_provider.dart`
- NEW: `address_provider.dart`, `favorite_provider.dart`, `router_provider.dart`

**Screens** (30 files → 30 screens)
- All Compose screens converted to Flutter Widget screens
- Layout logic preserved, platform widgets adapted

**Utilities** (7 utilities)
- `ShakeDetector.kt` → `shake_detector.dart`
- `LocationHelper.kt` → `location_helper.dart`
- `VoiceAssistant.kt` → (planned)
- Other utilities consolidated in `ui_utils.dart`

## 📋 Implementation Status

### ✅ Completed
- [x] Project structure and directory organization
- [x] All 30 screens implemented
- [x] 7 Riverpod providers configured
- [x] 4 data models with proper Dart structure
- [x] Material 3 theme system
- [x] GoRouter navigation setup
- [x] pubspec.yaml with 25+ dependencies
- [x] Mock data for demo mode
- [x] Product card widget
- [x] Utility functions (UI, Location, Shake detection)

### 🔄 In Progress / Planned
- [ ] Firebase integration (Auth, Firestore)
- [ ] Real data connectivity from Firebase
- [ ] Push notifications (Firebase Cloud Messaging)
- [ ] Payment processing (Stripe/PayPal)
- [ ] Advanced image upload to Cloudinary
- [ ] Chat with real-time Firestore listeners
- [ ] Analytics tracking
- [ ] Unit and widget tests
- [ ] CI/CD pipeline setup
- [ ] Performance optimization
- [ ] Internationalization (i18n)

### 🚀 Future Enhancements
- Admin dashboard
- Advanced search filters
- Recommendation engine
- Loyalty program
- Subscription model
- Multi-language support
- Dark mode optimization
- Offline support

## 📦 Dependencies

### Core Packages
- **flutter_riverpod** (2.4.8) - State management
- **go_router** (12.0.0) - Navigation
- **firebase_core** (2.24.0) - Firebase initialization
- **firebase_auth** (4.14.0) - Authentication
- **cloud_firestore** (4.14.0) - Database

### UI & Design
- **google_fonts** (6.1.0) - Typography
- **cached_network_image** (3.3.0) - Image loading
- **flutter_credit_card** (4.0.1) - Payment cards

### Services & APIs
- **google_sign_in** (6.1.5) - Google authentication
- **google_maps_flutter** (2.5.0) - Maps
- **google_mlkit_text_recognition** (0.9.0) - OCR
- **geolocator** (10.1.0) - Location services
- **location** (5.0.1) - Simplified location API

### Device Features
- **sensors_plus** (3.1.0) - Accelerometer (shake detection)
- **image_picker** (1.0.4) - Image selection
- **cloudinary_flutter** (2.0.0) - Cloud image storage

### Development Tools
- **flutter_lints** - Code quality
- **build_runner** - Code generation

**See `pubspec.yaml` for complete dependency list and versions**

## 🛠️ Useful Commands

```bash
# Development
flutter run              # Run on default device
flutter run -v          # Run with verbose output
flutter run --release   # Run optimized build

# Cleanup & Rebuild
flutter clean           # Remove build files
flutter pub get         # Install dependencies
flutter pub upgrade     # Update dependencies

# Build
flutter build apk       # Build Android APK
flutter build appbundle # Build Android App Bundle
flutter build ios       # Build iOS app

# Analysis & Testing
flutter analyze          # Check code issues
flutter test            # Run tests
flutter test --coverage # Run with coverage

# Development Tools
dart format lib/        # Format code
flutter doctor          # Check environment setup
flutter devices         # List available devices

# Debugging
flutter run -v          # Verbose mode
flutter run --debug     # Debug mode

# Hot Reload/Restart (during flutter run)
# r - Hot reload
# R - Hot restart
# d - Detach
# q - Quit
```

## 🐛 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Flutter not found" | Add Flutter to PATH or use full path |
| "No devices available" | Start emulator: `flutter emulators --launch pixel_6` |
| "Build failed" | Run `flutter clean` then `flutter pub get` |
| "MissingPluginException" | Rebuild app: `flutter clean && flutter run` |
| "Gradle build failed" | Check `android/build.gradle` and `android/app/build.gradle` |

**For detailed troubleshooting, see [GETTING_STARTED.md](GETTING_STARTED.md)**

## 🏗️ Architecture

### Design Pattern: MVVM + Riverpod

```
┌─────────────────────────────────────┐
│        UI Layer (Screens)           │
│  ├── Login / Authentication        │
│  ├── Home / Product Browsing       │
│  ├── Cart / Checkout               │
│  ├── Orders / Profile              │
│  └── Settings / Help               │
└──────────────────┬──────────────────┘
                   │ (watches)
┌──────────────────▼──────────────────┐
│     State Management (Riverpod)     │
│  ├── auth_provider                 │
│  ├── cart_provider                 │
│  ├── product_provider              │
│  ├── order_provider                │
│  ├── address_provider              │
│  ├── favorite_provider             │
│  └── router_provider               │
└──────────────────┬──────────────────┘
                   │ (uses)
┌──────────────────▼──────────────────┐
│      Data Layer (Models)            │
│  ├── Product / Category / Review   │
│  ├── User / Address / Card        │
│  ├── Order / OrderItem            │
│  └── Cart management              │
└──────────────────┬──────────────────┘
                   │ (connects to)
┌──────────────────▼──────────────────┐
│    Backend & Services               │
│  ├── Firebase Auth                 │
│  ├── Firestore Database            │
│  ├── Firebase Storage              │
│  └── External APIs                 │
└─────────────────────────────────────┘
```

### Data Flow
1. **UI** renders based on provider state
2. **User action** → Provider notifier method called
3. **State updates** → All watchers notified
4. **UI rebuilds** with new state

### Key Principles
- **Reactive**: UI automatically updates on state changes
- **Immutable**: State objects don't change, new ones are created
- **Type-safe**: Full Dart type system leveraged
- **Testable**: Providers are easily mockable for tests

## License

This project is part of Lanka Smart Mart.

## Support

For issues or questions, please contact the development team.
