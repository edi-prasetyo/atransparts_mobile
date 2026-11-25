import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../modules/auth/models/auth_model.dart';
import '../services/api_service.dart';
import '../services/secure_service.dart';

class AuthState {
  final bool isLoggedIn;
  final String? token;
  final int isVerified;
  final bool isLoading;

  const AuthState({
    this.isLoggedIn = false,
    this.token,
    this.isVerified = 0,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? token,
    int? isVerified,
    bool? isLoading,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      isVerified: isVerified ?? this.isVerified,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState(isLoading: true);
  }

  Future<void> initialize() async {
    if (!state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      final storage = ref.read(secureStorageProvider);
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _refreshAuth(refreshToken);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      // print('DEBUG: [AUTH_NOTIFIER] initAuth error: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _refreshAuth(String refreshToken) async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiService.baseUrl,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      final response = await dio.post(
        '/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthResponse.fromJson(response.data);
        final storage = ref.read(secureStorageProvider);
        await storage.saveTokens(
          authResponse.accessToken,
          authResponse.refreshToken,
          authResponse.expiresIn,
        );
        state = state.copyWith(
          isLoggedIn: true,
          token: authResponse.accessToken,
          isVerified: authResponse.isVerified,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      // print('DEBUG: [AUTH_NOTIFIER] refreshAuth error: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  void login(String token, {int isVerified = 0}) {
    // print(
    //   'DEBUG: [AUTH_NOTIFIER] login called, token=$token, isVerified=$isVerified',
    // );
    state = state.copyWith(
      isLoggedIn: true,
      token: token,
      isVerified: isVerified,
      isLoading: false,
    );
    // print(
    //   'DEBUG: [AUTH_NOTIFIER] state updated: isLoggedIn=${state.isLoggedIn}, isVerified=${state.isVerified}',
    // );
  }

  void logout() {
    // print('DEBUG: [AUTH_NOTIFIER] logout called');
    state = const AuthState(
      isLoggedIn: false,
      token: null,
      isVerified: 0,
      isLoading: false,
    );
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
