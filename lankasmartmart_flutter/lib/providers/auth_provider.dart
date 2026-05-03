import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_models.dart';
import '../models/user_models.dart';

// Auth state
class AuthState {
  final bool isAuthenticated;
  final UserData? user;
  final String? error;
  final bool isLoading;

  AuthState({
    this.isAuthenticated = false,
    this.user,
    this.error,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserData? user,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void logout() {
    state = AuthState();
  }

  void loginWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: Implement Firebase sign-in
      // For now, mock login
      await Future.delayed(const Duration(seconds: 2));
      final user = UserData(
        uid: 'mock_uid',
        name: 'Test User',
        email: email,
      );
      state = AuthState(
        isAuthenticated: true,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void signUpWithEmail(String email, String password, String name) async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: Implement Firebase sign-up
      await Future.delayed(const Duration(seconds: 2));
      final user = UserData(
        uid: 'mock_uid',
        name: name,
        email: email,
      );
      state = AuthState(
        isAuthenticated: true,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void signInWithGoogle() async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: Implement Google Sign-In
      await Future.delayed(const Duration(seconds: 2));
      final user = UserData(
        uid: 'mock_google_uid',
        name: 'Google User',
        email: 'user@gmail.com',
      );
      state = AuthState(
        isAuthenticated: true,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}
