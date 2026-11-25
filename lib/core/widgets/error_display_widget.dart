import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ============================================================
/// 1. JENIS ERROR — HANYA TRANSIENT
/// ============================================================
/// Sengaja dibatasi cuma 3, sesuai kebutuhan:
/// - noInternet : perangkat tidak terhubung ke internet
/// - timeout    : request memakan waktu terlalu lama
/// - serverError: server tidak bisa dihubungi / down / 5xx
enum TransientErrorType { noInternet, timeout, serverError }

/// ============================================================
/// 2. MODEL ERROR
/// ============================================================
class TransientErrorData {
  final TransientErrorType type;
  final String? customMessage;
  final int? statusCode;
  final Object? original;

  const TransientErrorData(
    this.type, {
    this.customMessage,
    this.statusCode,
    this.original,
  });

  /// Konversi exception apa pun jadi TransientErrorData.
  /// Return null kalau errornya BUKAN termasuk kategori transient
  /// (misal validasi form, 401, 404, parsing error) — biar
  /// error semacam itu tetap ditangani terpisah oleh halaman,
  /// bukan lewat modal ini.
  static TransientErrorData? fromException(Object error) {
    _logError(error);

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.transformTimeout:
          return TransientErrorData(
            TransientErrorType.timeout,
            original: error,
          );

        case DioExceptionType.connectionError:
          if (error.error is SocketException) {
            final msg = (error.error as SocketException).message.toLowerCase();
            if (msg.contains('refused') || msg.contains('reset')) {
              return TransientErrorData(
                TransientErrorType.serverError,
                original: error,
              );
            }
          }
          return TransientErrorData(
            TransientErrorType.noInternet,
            original: error,
          );

        case DioExceptionType.badResponse:
          final code = error.response?.statusCode;
          if (code != null && code >= 500) {
            return TransientErrorData(
              TransientErrorType.serverError,
              statusCode: code,
              original: error,
            );
          }
          // Status code lain (401/403/404/422 dst) BUKAN transient,
          // biarkan halaman yang menanganinya sendiri.
          return null;

        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return TransientErrorData(
              TransientErrorType.noInternet,
              original: error,
            );
          }
          return null;

        case DioExceptionType.cancel:
        case DioExceptionType.badCertificate:
          return null;
      }
    }

    if (error is SocketException) {
      return TransientErrorData(TransientErrorType.noInternet, original: error);
    }

    // Bukan termasuk error transient
    return null;
  }
}

void _logError(Object error) {
  debugPrint('[TransientError] $error');
}

/// ============================================================
/// 3. KONFIGURASI TAMPILAN
/// ============================================================
class _ErrorContent {
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  const _ErrorContent({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });
}

_ErrorContent _getContent(TransientErrorData error) {
  switch (error.type) {
    case TransientErrorType.noInternet:
      return const _ErrorContent(
        icon: Icons.wifi_off_rounded,
        title: 'Tidak Ada Koneksi Internet',
        message: 'Periksa koneksi internet kamu, lalu coba lagi.',
        color: Color(0xFFFF9800),
      );
    case TransientErrorType.timeout:
      return const _ErrorContent(
        icon: Icons.timer_off_rounded,
        title: 'Waktu Habis',
        message: 'Permintaan memakan waktu terlalu lama. Coba lagi ya.',
        color: Color(0xFF3B82F6),
      );
    case TransientErrorType.serverError:
      return const _ErrorContent(
        icon: Icons.cloud_off_rounded,
        title: 'Server Bermasalah',
        message:
            'Terjadi kesalahan di server kami. Silakan coba beberapa saat lagi.',
        color: Color(0xFFEF4444),
      );
  }
}

/// ============================================================
/// 4. MODAL DIALOG — modern, icon di atas, close (X) bulat
///    di pojok kanan atas, message di bawah icon, tombol
///    "Coba Lagi" di paling bawah.
/// ============================================================
class TransientErrorDialog extends StatelessWidget {
  final TransientErrorData error;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final String retryLabel;

  const TransientErrorDialog({
    super.key,
    required this.error,
    this.onRetry,
    this.onDismiss,
    this.retryLabel = 'Coba Lagi',
  });

  @override
  Widget build(BuildContext context) {
    final content = _getContent(error);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                // --- Icon lingkaran di atas ---
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: content.color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(content.icon, size: 34, color: content.color),
                ),
                const SizedBox(height: 20),
                // --- Judul ---
                Text(
                  content.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Pesan ---
                Text(
                  error.customMessage ?? content.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                // --- Tombol Coba Lagi ---
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      onRetry?.call();
                      onDismiss?.call();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: content.color,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      retryLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // --- Tombol close (X) bulat, pojok kanan atas ---
            Positioned(
              top: -4,
              right: -4,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onDismiss?.call(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper untuk menampilkan modal langsung dari mana saja yang
/// punya BuildContext. Return null otomatis (tidak menampilkan
/// apa pun) kalau error yang dilempar bukan termasuk transient.
///
/// Contoh pemakaian:
/// ```dart
/// try {
///   await fetchData();
/// } catch (e) {
///   final shown = showTransientErrorDialog(context, error: e, onRetry: fetchData);
///   if (!shown) {
///     // tangani error non-transient (401, 404, validasi, dst) di sini
///   }
/// }
/// ```
bool showTransientErrorDialog(
  BuildContext context, {
  required Object error,
  VoidCallback? onRetry,
  String retryLabel = 'Coba Lagi',
}) {
  final data = TransientErrorData.fromException(error);
  if (data == null) return false;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => TransientErrorDialog(
      error: data,
      onRetry: onRetry,
      retryLabel: retryLabel,
    ),
  );
  return true;
}

/// ============================================================
/// 5. GLOBAL — otomatis muncul dari mana pun tanpa kode per halaman
/// ============================================================
/// State global: error transient yang sedang perlu ditampilkan.
class GlobalTransientErrorNotifier extends Notifier<TransientErrorData?> {
  @override
  TransientErrorData? build() => null;

  void report(Object error) {
    final data = TransientErrorData.fromException(error);
    if (data != null) state = data;
  }

  void clear() => state = null;
}

final globalTransientErrorProvider =
    NotifierProvider<GlobalTransientErrorNotifier, TransientErrorData?>(
      () => GlobalTransientErrorNotifier(),
    );

/// Dio interceptor — pasang sekali, semua request otomatis
/// melaporkan error transient ke provider di atas.
///
/// ```dart
/// dio.interceptors.add(GlobalTransientErrorInterceptor(ref));
/// ```
class GlobalTransientErrorInterceptor extends Interceptor {
  final Ref ref;
  GlobalTransientErrorInterceptor(this.ref);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ref.read(globalTransientErrorProvider.notifier).report(err);
    handler.next(err);
  }
}

/// Pasang SEKALI di root widget (di dalam MaterialApp/atas Navigator),
/// modal akan otomatis muncul kapan pun ada error transient yang
/// dilaporkan ke provider, tanpa perlu kode tambahan di halaman lain.
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return GlobalTransientErrorListener(child: MaterialApp(...));
/// }
/// ```
class GlobalTransientErrorListener extends ConsumerStatefulWidget {
  final Widget child;
  const GlobalTransientErrorListener({super.key, required this.child});

  @override
  ConsumerState<GlobalTransientErrorListener> createState() => _GlobalTransientErrorListenerState();
}

class _GlobalTransientErrorListenerState extends ConsumerState<GlobalTransientErrorListener> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final errorData = ref.watch(globalTransientErrorProvider);

    if (errorData != null && !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {});
      });
    }

    if (errorData == null) {
      _dialogShown = false;
    }

    return Stack(
      children: [
        widget.child,
        if (errorData != null)
          Positioned.fill(
            child: TransientErrorDialog(
              error: errorData,
              onRetry: () {},
              onDismiss: () {
                ref.read(globalTransientErrorProvider.notifier).clear();
              },
            ),
          ),
      ],
    );
  }
}

/// ============================================================
/// 6. CONTOH PEMAKAIAN
/// ============================================================
/// A) Manual per halaman (tanpa Riverpod global state):
/// ```dart
/// try {
///   await fetchData();
/// } catch (e) {
///   showTransientErrorDialog(context, error: e, onRetry: fetchData);
/// }
/// ```
///
/// B) Otomatis global (Riverpod + Dio interceptor):
/// ```dart
/// // main.dart
/// runApp(ProviderScope(child: MyApp()));
///
/// // MyApp
/// class MyApp extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final dio = Dio()..interceptors.add(GlobalTransientErrorInterceptor(ref));
///     return GlobalTransientErrorListener(
///       child: MaterialApp(home: HomePage(dio: dio)),
///     );
///   }
/// }
/// ```
