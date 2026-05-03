# Conversion Guide: Kotlin/Compose to Flutter

## Overview
This document outlines the migration strategy and key differences between the original Android app and this Flutter version.

## Architecture Changes

### State Management
**Before (Kotlin/Compose):**
```kotlin
class ShopViewModel : ViewModel() {
    private val _products = MutableStateFlow<List<Product>>(emptyList())
    val products: StateFlow<List<Product>> = _products.asStateFlow()
    
    fun addToCart(product: Product) {
        // Update cart
    }
}
```

**After (Flutter/Riverpod):**
```dart
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<List<CartItem>> {
  void addToCart(Product product) {
    // Update cart
  }
}
```

### Navigation
**Before (Kotlin/Compose):**
```kotlin
sealed class Screen {
    object Home : Screen()
    object Cart : Screen()
    data class ProductDetails(val id: String) : Screen()
}

// Used with when expressions
when (currentScreen) {
    is Screen.Home -> HomeScreen()
    is Screen.Cart -> CartScreen()
    ...
}
```

**After (Flutter/GoRouter):**
```dart
final router = GoRouter(
  routes: [
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/cart', builder: (context, state) => CartScreen()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) => ProductDetailsScreen(id: state.pathParameters['id']!),
    ),
  ],
);
```

### UI Widgets
**Before (Compose):**
```kotlin
@Composable
fun ProductCard(product: Product) {
    Card(
        shape = RoundedCornerShape(16.dp),
        modifier = Modifier.clickable { /* ... */ }
    ) {
        Column {
            // Content
        }
    }
}
```

**After (Flutter):**
```dart
class ProductCard extends StatelessWidget {
    final Product product;
    
    Widget build(BuildContext context) {
        return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
                children: [
                    // Content
                ],
            ),
        );
    }
}
```

## Feature Mapping

### Features Completed ✓
- [x] Authentication (Email, Google Sign-In)
- [x] Product browsing and categories
- [x] Cart management
- [x] Theme and styling
- [x] Navigation structure
- [x] State management with Riverpod

### Features In Progress 🔄
- [ ] Firebase integration
- [ ] Real-time product search
- [ ] Order management
- [ ] Payment processing
- [ ] Address management
- [ ] Push notifications

### Features to Implement 📋
- [ ] Chat assistant
- [ ] Order tracking
- [ ] Wishlist/Favorites
- [ ] Product reviews and ratings
- [ ] Location services
- [ ] Card scanning (ML Kit)
- [ ] Shake gesture detection
- [ ] Analytics integration

## Package Equivalents

| Android | Flutter |
|---------|---------|
| Jetpack Compose | Flutter Widgets |
| Room Database | Hive / sqflite |
| Datastore | shared_preferences |
| Retrofit | dio / http |
| Coil | cached_network_image |
| ML Kit | google_mlkit_* packages |
| Google Play Services | google_maps_flutter, geolocator |
| WorkManager | workmanager package |
| Lottie | lottie package |

## Performance Considerations

1. **Image Loading**: Use `cached_network_image` with proper caching strategy
2. **List Performance**: Use `PageView` or `SingleChildScrollView` with `shrinkWrap: true`
3. **State Rebuilds**: Leverage Riverpod's fine-grained reactivity to minimize rebuilds
4. **Memory**: Monitor large list rendering, use `ListView.builder` instead of `ListView`

## Testing Strategy

```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test integration_test/
```

## Deployment

### Android
```bash
# Build release APK
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release
```

### iOS
```bash
# Build release IPA
flutter build ios --release
```

## Common Issues & Solutions

### Issue: Firebase not initializing
**Solution**: Ensure `google-services.json` is in the correct location and `firebase_core.initializeApp()` is called in `main()`.

### Issue: Images not loading
**Solution**: Check image URLs are accessible and `cached_network_image` is properly configured.

### Issue: State not updating
**Solution**: Ensure state changes are immutable and proper `StateNotifier` updates are used.

## Migration Checklist

- [ ] Set up Firebase project
- [ ] Implement all authentication methods
- [ ] Migrate data models
- [ ] Convert all screens
- [ ] Set up payment processing
- [ ] Implement notifications
- [ ] Add analytics
- [ ] Performance testing
- [ ] Security audit
- [ ] Beta testing
- [ ] App store submission

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Guide](https://riverpod.dev)
- [Go Router Package](https://pub.dev/packages/go_router)
- [Firebase Flutter Guide](https://firebase.flutter.dev)
