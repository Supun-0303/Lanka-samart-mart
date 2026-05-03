import 'package:flutter/material.dart';

class AppConstants {
  // API
  static const String apiBaseUrl = 'https://api.lankasmartmart.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Firebase
  static const String firebaseProjectId = 'lankasmartmart';
  
  // Google
  static const String googleMapsKey = 'YOUR_GOOGLE_MAPS_KEY';
  static const String googleSignInClientId = '990055502440-h8ridku5nq606vjsraqmogfgr0vu1pqb.apps.googleusercontent.com';
  
  // Cloudinary
  static const String cloudinaryCloudName = 'dqyilatyp';
  
  // App
  static const String appName = 'Lanka Smart Mart';
  static const String appVersion = '1.0.0';
  static const String appBuild = '1';
  
  // Timeouts
  static const Duration cartSaveDelay = Duration(milliseconds: 500);
  static const Duration notificationDuration = Duration(seconds: 2);
  
  // Pagination
  static const int pageSize = 20;
  static const int initialLoadCount = 10;
  
  // Images
  static const String assetsImagePath = 'assets/images';
  static const String assetsIconPath = 'assets/icons';
  
  // Storage Keys
  static const String userPrefsKey = 'user_prefs';
  static const String cartKey = 'cart_items';
  static const String favoriteKey = 'favorites';
  static const String addressesKey = 'addresses';
  static const String cardsKey = 'payment_cards';
}
