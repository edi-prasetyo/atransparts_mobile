import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../core/services/api_service.dart';
import '../../../core/exceptions/validation_exception.dart';
import '../../../core/services/network_service.dart';
import '../../../core/services/secure_service.dart';
import '../../../core/services/public_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/auth_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../profile/controllers/profile_controller.dart';
import 'dart:io';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthResponse?>(() {
      return AuthController();
    });

class AuthController extends AsyncNotifier<AuthResponse?> {
  CancelToken? _loginCancelToken;
  // bool _isRefreshing = false;

  // static int _vToInt(dynamic v) {
  //   if (v is int) return v;
  //   if (v is bool) return v ? 1 : 0;
  //   if (v is String) return int.tryParse(v) ?? 0;
  //   return 0;
  // }

  @override
  FutureOr<AuthResponse?> build() async {
    final token = await ref.read(secureStorageProvider).getToken();

    if (token != null && token.isNotEmpty) {
      return AuthResponse(
        accessToken: token,
        refreshToken:
            await ref.read(secureStorageProvider).getRefreshToken() ?? '',
        expiresIn:
            int.tryParse(
              await ref.read(secureStorageProvider).getExpiresIn() ?? '0',
            ) ??
            0,
      );
    }
    return null;
  }

  Future<void> login(String identifier, String password) async {
    // print('=== LOGIN DIPANGGIL ===');
    _loginCancelToken?.cancel();
    _loginCancelToken = CancelToken();

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dio = ref.read(publicProvider);

      final fcmToken = await _fetchFcmToken();
      // print('FCM Token: $fcmToken');

      // Backend /login menerima identifier (email ATAU nomor telepon) pada
      // field `email`. Nomor telepon dinormalisasi ke format lokal 0XXXXXXXXX
      // (mis. 0812...) agar konsisten dengan format tersimpan di backend.
      final identifierValue = _normalizeIdentifier(identifier);
      final Map<String, dynamic> data = {
        'email': identifierValue,
        'password': password,
        'fcm_token': fcmToken,
      };

      // print('LOGIN DATA: $data');

      try {
        final response = await dio.post(
          '/login',
          data: data,
          cancelToken: _loginCancelToken,
        );

        final authData = AuthResponse.fromJson(response.data);

        // Print token dari response API
        // print('Access Token: ${authData.accessToken}');
        // print('Refresh Token: ${authData.refreshToken}');

        // Simpan token
        await ref
            .read(secureStorageProvider)
            .saveTokens(
              authData.accessToken,
              authData.refreshToken,
              authData.expiresIn,
            );

        // Verifikasi token yang tersimpan
        final storage = ref.read(secureStorageProvider);

        // print('Stored Access Token: ${await storage.getToken()}');
        // print('Stored Refresh Token: ${await storage.getRefreshToken()}');

        // "Sesi OTP" login: bila belum terverifikasi, simpan contact supaya
        // resend OTP dapat dikirim via email & phone meski app restart.
        if (authData.isVerified != 1) {
          await storage.savePendingOtpContact(
            email: authData.email ?? identifierValue,
            phone: authData.phone,
          );
        } else {
          await storage.clearPendingOtpContact();
        }

        ref
            .read(authProvider.notifier)
            .login(authData.accessToken, isVerified: authData.isVerified);

        return authData;
      } on DioException catch (e) {
        // print('LOGIN ERROR status: ${e.response?.statusCode}');
        // print('LOGIN ERROR body: ${e.response?.data}');
        final responseData =
            e.response?.data as Map<String, dynamic>? ?? <String, dynamic>{};
        final message =
            responseData['message']?.toString() ?? 'Login gagal, coba lagi';
        throw Exception(message);
      }
    });
  }

  /// Normalisasi identifier agar konsisten ke format yang disimpan backend.
  /// - Email dikembalikan apa adanya.
  /// - Nomor telepon diubah ke format lokal 0XXXXXXXXX (tanpa `+`, spasi, atau
  ///   awalan `62`). Contoh: `+62812...`, `62812...`, `812...` -> `0812...`.
  String _normalizeIdentifier(String value) {
    final trimmed = value.trim();
    if (trimmed.contains('@')) return trimmed;

    final digits = trimmed.replaceAll(RegExp(r'[\D]'), '');
    if (digits.isEmpty) return trimmed;
    if (digits.startsWith('62')) return '0${digits.substring(2)}';
    if (digits.startsWith('0')) return digits;
    return '0$digits';
  }

  /// Ambil FCM token (sama seperti pada /login), agar bisa dikirim ke backend
  // pada register maupun login.
  Future<String?> _fetchFcmToken() async {
  try {
    final messaging = FirebaseMessaging.instance;

    if (Platform.isIOS) {
      String? apnsToken;

      for (int i = 0; i < 10; i++) {
        apnsToken = await messaging.getAPNSToken();

        debugPrint(
          '[FCM] APNs Token attempt ${i + 1}: $apnsToken',
        );

        if (apnsToken != null && apnsToken.isNotEmpty) {
          break;
        }

        await Future.delayed(const Duration(seconds: 1));
      }

      if (apnsToken == null || apnsToken.isEmpty) {
        debugPrint('[FCM] APNs token belum tersedia');
        return null;
      }

      debugPrint('[FCM] APNs Token: $apnsToken');
    }

    final token = await messaging.getToken();

    debugPrint('[FCM] FCM Token: $token');

    return token;
  } catch (e) {
    debugPrint('[FCM_TOKEN] Gagal: $e');
    return null;
  }
}

  Future<String> forgotPassword(String identifier) async {
    try {
      final dio = ref.read(publicProvider);

      final normalizedValue = _normalizeIdentifier(identifier);
      final response = await dio.post(
        '/forgot-password',
        data: {"email": normalizedValue},
      );

      final responseData =
          response.data as Map<String, dynamic>? ?? <String, dynamic>{};
      final message =
          responseData['message']?.toString() ??
          'Permintaan reset password berhasil';

      return message;
    } on DioException catch (e) {
      final responseData =
          e.response?.data as Map<String, dynamic>? ?? <String, dynamic>{};
      final message =
          responseData['message']?.toString() ??
          'Gagal mengirim permintaan reset password';
      // print('DEBUG: [FORGOT_PASSWORD] Gagal: $message');
      throw Exception(message);
    } catch (e) {
      // print('DEBUG: [FORGOT_PASSWORD] Gagal: $e');
      rethrow;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    // Simpan state sebelumnya (berisi access_token dari register/login) agar
    // tidak hilang ketika response /verify-otp tidak mengembalikan token baru.
    final previousData = state.value;
    state = const AsyncLoading();
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.post('/verify-otp', data: {'otp': otp});

      final responseData =
          response.data as Map<String, dynamic>? ?? <String, dynamic>{};
      final user =
          responseData['user'] as Map<String, dynamic>? ?? <String, dynamic>{};
      // Nilai is_verified diambil langsung dari API (bukan diasumsikan).
      final bool isVerified =
          user['is_verified'] == true || user['is_verified'] == 1;

      // 2xx + is_verified == true diperlukan agar sukses. Bukan 2xx atau
      // is_verified belum true -> jangan bypass, lempar pesan asli API agar
      // UI menampilkannya apa adanya.
      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) >= 300 ||
          !isVerified) {
        final message =
            responseData['message']?.toString() ?? 'Verifikasi gagal';
        // print('DEBUG: [VERIFY_OTP] Tidak berhasil: ${response.data}');
        throw Exception(message);
      }

      final token = previousData?.accessToken;
      if (token != null) {
        await ref.read(secureStorageProvider).clearPendingOtpContact();
        ref.read(authProvider.notifier).login(token, isVerified: 1);
      }

      // print('DEBUG: [VERIFY_OTP] Berhasil diverifikasi.');
      state = AsyncData(previousData);
      return true;
    } catch (e) {
      // print('DEBUG: [VERIFY_OTP] Gagal: $e');
      state = AsyncData(previousData);
      rethrow; // Biarkan UI menangkap error untuk menampilkan apa adanya
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    // print('=== REGISTER DIPANGGIL ===');
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final dio = ref.read(publicProvider);

      // Endpoint /register tidak menerima fcm_token, jadi fcm dikirim nanti
      // melalui login() setelah OTP berhasil diverifikasi.
      final response = await dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final responseData = response.data as Map<String, dynamic>;

      // 2xx = sukses (bisa 200/201). 422 = validation error -> lempar
      // ValidationException agar UI dapat menampilkan error per-field.
      final statusCode = response.statusCode ?? 0;
      if (statusCode == 422) {
        final errorsRaw =
            responseData['errors'] as Map<String, dynamic>? ??
            <String, dynamic>{};
        final fieldErrors = <String, List<String>>{};
        errorsRaw.forEach((key, value) {
          if (value is List) {
            fieldErrors[key] = value.map((e) => e.toString()).toList();
          } else if (value is String) {
            fieldErrors[key] = [value];
          }
        });
        final message = responseData['message']?.toString();
        debugPrint('DEBUG: [REGISTER] Validation error: ${response.data}');
        throw ValidationException(
          fieldErrors: fieldErrors,
          message: message,
          requestOptions: response.requestOptions,
        );
      }

      if (statusCode < 200 || statusCode >= 300) {
        final message = responseData['message']?.toString();
        debugPrint('DEBUG: [REGISTER] Gagal: ${response.data}');
        throw Exception(
          (message != null && message.isNotEmpty)
              ? message
              : 'Registrasi gagal',
        );
      }

      final user =
          responseData['user'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final accessToken = (responseData['access_token'] ?? '').toString();
      final refreshToken = (responseData['refresh_token'] ?? '').toString();
      final expiresIn =
          int.tryParse((responseData['expires_in'] ?? 0).toString()) ?? 0;
      final isVerified =
          (user['is_verified'] == true || user['is_verified'] == 1) ? 1 : 0;
      final respEmail = (user['email'] ?? responseData['email'] ?? '')
          .toString();
      final respPhone = (user['phone'] ?? responseData['phone'] ?? '')
          .toString();
      final respOtpExpiresAt =
          (user['otp_expires_at'] ?? responseData['otp_expires_at'])
              ?.toString();

      // Simpan access_token + refresh_token ke secure storage agar session
      // tersimpan (sama seperti login).
      // print(
      //   'DEBUG: [REGISTER] Saving tokens: access=$accessToken, refresh=$refreshToken, expires=$expiresIn',
      // );
      await ref
          .read(secureStorageProvider)
          .saveTokens(accessToken, refreshToken, expiresIn);
      // print('DEBUG: [REGISTER] Tokens saved');

      // print('DEBUG: [REGISTER] isVerified saved: $isVerified');

      // "Sesi OTP register": simpan contact agar resend OTP dapat dikirim
      // via email & phone meski app restart / sesi register terasa hilang.
      await ref
          .read(secureStorageProvider)
          .savePendingOtpContact(email: respEmail, phone: respPhone);

      // Set isLoggedIn & isVerified. Jika is_verified == 0, router akan
      // mengarahkan otomatis ke /verify (bukan ke /home).
      // print(
      //   'DEBUG: [REGISTER] Before login: token=$accessToken, isVerified=$isVerified',
      // );
      ref
          .read(authProvider.notifier)
          .login(accessToken, isVerified: isVerified);
      // print('DEBUG: [REGISTER] After login');

      final authData = AuthResponse(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
        isVerified: isVerified,
        email: respEmail,
        phone: respPhone,
        otpExpiresAt: respOtpExpiresAt,
      );

      debugPrint('REGISTER Access Token: $accessToken');
      return authData;
    });
    state = result;

    // AsyncValue.guard menangkap exception dan mengembalikannya sebagai
    // AsyncError pada `result` — tidak me-rethrow ke caller. Re-throw manual
    // agar UI bisa menangani ValidationException / Exception untuk response
    // 422 / non-2xx dan menampilkan error per-field.
    if (result.hasError && result.error != null) {
      throw result.error!;
    }
  }

  Future<Map<String, dynamic>?> resendOtp({
    String? email,
    String? phone,
  }) async {
    if ((email == null || email.isEmpty) && (phone == null || phone.isEmpty)) {
      throw Exception('Email atau nomor telepon wajib dikirim');
    }

    try {
      final dio = ref.read(dioProvider);

      final Map<String, dynamic> data = <String, dynamic>{};
      if (email != null && email.isNotEmpty) data['email'] = email;
      if (phone != null && phone.isNotEmpty) data['phone'] = phone;

      final response = await dio.post('/resend-otp', data: data);

      // 2xx = sukses. Bukan 2xx -> lempar pesan API apa adanya.
      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) >= 300) {
        final body = response.data as Map<String, dynamic>? ?? {};
        final message =
            body['message']?.toString() ?? 'Gagal mengirim ulang kode OTP';
        // print('DEBUG: [RESEND_OTP] Gagal: ${response.data}');
        throw Exception(message);
      }

      // print('DEBUG: [RESEND_OTP] ${response.data['message']}');
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      // print('DEBUG: [RESEND_OTP] Gagal: $e');
      rethrow;
    }
  }

  void updateState(AuthResponse newData) {
    state = AsyncData(newData);
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      final dio = ref.read(dioProvider);
      await dio.post('/logout');
    } catch (e) {
      debugPrint('DEBUG: [LOGOUT] API Gagal: $e');
    } finally {
      await ref.read(secureStorageProvider).clearAll();
      ref.read(authProvider.notifier).logout();
      ref.invalidate(profileControllerProvider);
      state = const AsyncData(null);
    }
  }
}
