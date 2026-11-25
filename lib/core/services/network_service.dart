import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/auth/models/auth_model.dart';
import 'api_service.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../core/providers/auth_provider.dart';
import 'secure_service.dart';
import '../widgets/error_display_widget.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiService.baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  // Flag untuk mencegah multiple refresh & infinite loop
  int refreshAttempts = 0;
  Completer<void>? refreshCompleter;

  dio.interceptors.add(GlobalTransientErrorInterceptor(ref));

  final retryDio = Dio(dio.options);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await ref.read(secureStorageProvider).getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        final path = error.requestOptions.path;

        // 1. Cek status 401 dan pastikan bukan dari endpoint krusial
        if (error.response?.statusCode == 401 &&
            !path.contains('/login') &&
            !path.contains('/refresh') &&
            !path.contains('/logout')) {
          if (refreshAttempts >= 3) {
            // print(
            //   'DEBUG: [INTERCEPTOR] Max refresh attempts reached, clearing auth',
            // );
            refreshAttempts = 0;
            refreshCompleter?.complete();
            refreshCompleter = null;
            await ref.read(secureStorageProvider).clearAll();
            ref.read(authProvider.notifier).logout();
            return handler.next(error);
          }

          if (refreshCompleter != null) {
            await refreshCompleter!.future;
            final newToken = await ref.read(secureStorageProvider).getToken();
            if (newToken == null) {
              return handler.next(error);
            }
            final opts = error.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newToken';
            final retryResponse = await retryDio.fetch(opts);
            return handler.resolve(retryResponse);
          }

          refreshCompleter = Completer<void>();

          try {
            // print('DEBUG: [INTERCEPTOR] Menjalankan Refresh Token...');

            final refreshToken = await ref
                .read(secureStorageProvider)
                .getRefreshToken();

            if (refreshToken == null || refreshToken.isEmpty) {
              // print('DEBUG: [INTERCEPTOR] Refresh Token kosong');
              return handler.next(error);
            }

            final refreshDio = Dio(dio.options);
            final response = await refreshDio.post(
              '/refresh',
              data: {'refresh_token': refreshToken},
            );

            // print(
            //   'DEBUG: [INTERCEPTOR] Refresh Response: ${response.statusCode} ${response.data}',
            // );

            final newData = AuthResponse.fromJson(response.data);

            await ref
                .read(secureStorageProvider)
                .saveTokens(
                  newData.accessToken,
                  newData.refreshToken,
                  newData.expiresIn,
                );

            // FIX: pakai isVerified hasil parsing response refresh (newData),
            // bukan nilai lama dari authProvider. Sebelumnya kode ini
            // mengambil ulang isVerified dari state lama (currentVerified),
            // sehingga status verifikasi terbaru dari server tidak pernah
            // sampai ke state, dan isVerified bisa "turun" jadi 0 walau
            // server sudah mengirim 1.
            // print(
            //   'DEBUG: [INTERCEPTOR] newData.isVerified=${newData.isVerified}',
            // );
            ref
                .read(authProvider.notifier)
                .login(newData.accessToken, isVerified: newData.isVerified);

            ref.read(authControllerProvider.notifier).updateState(newData);

            final opts = error.requestOptions;
            opts.headers['Authorization'] = 'Bearer ${newData.accessToken}';

            final retryResponse = await retryDio.fetch(opts);
            refreshAttempts = 0;
            refreshCompleter?.complete();
            refreshCompleter = null;
            return handler.resolve(retryResponse);
          } catch (e) {
            // print('DEBUG: [INTERCEPTOR] Refresh Gagal total: $e');
            refreshAttempts = 0;
            refreshCompleter?.complete();
            refreshCompleter = null;
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
});
