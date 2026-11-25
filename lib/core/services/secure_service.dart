import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final secureStorageProvider = Provider((ref) => const SecureService());

class SecureService {
  final _storage = const FlutterSecureStorage();
  const SecureService();

  static const _keyPendingOtpEmail = 'pending_otp_email';
  static const _keyPendingOtpPhone = 'pending_otp_phone';
  static const _keyLocationPermission = 'location_permission_granted';
  static const _keyNotificationPermission = 'notification_permission_granted';
  static const _keyDarkMode = 'dark_mode';

  // "Sesi OTP" yangdipakai untuk resend OTP (bisa dari alur register maupun
  // login). Dikosongkan begitu user berhasil diverifikasi.
  Future<void> savePendingOtpContact({
    required String email,
    String? phone,
  }) async {
    await _storage.write(key: _keyPendingOtpEmail, value: email);
    if (phone != null && phone.isNotEmpty) {
      await _storage.write(key: _keyPendingOtpPhone, value: phone);
    }
  }

  Future<String?> getPendingOtpEmail() =>
      _storage.read(key: _keyPendingOtpEmail);

  Future<String?> getPendingOtpPhone() =>
      _storage.read(key: _keyPendingOtpPhone);

  Future<void> clearPendingOtpContact() async {
    await _storage.delete(key: _keyPendingOtpEmail);
    await _storage.delete(key: _keyPendingOtpPhone);
  }

  Future<void> saveTokens(String access, String refresh, int expires) async {
    // print(
    //   'DEBUG: [SECURE_STORAGE] Saving tokens: access=$access, refresh=$refresh, expires=$expires',
    // );
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
    await _storage.write(key: 'expires_in', value: expires.toString());
    // print('DEBUG: [SECURE_STORAGE] Tokens saved');
  }

  Future<String?> getToken() => _storage.read(key: 'access_token');
  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: 'refresh_token');
    // print('DEBUG: [SECURE_STORAGE] getRefreshToken=$token');
    return token;
  }

  Future<String?> getExpiresIn() => _storage.read(key: 'expires_in');

  Future<void> saveLocationPermissionGranted() async {
    await _storage.write(key: _keyLocationPermission, value: 'true');
  }

  Future<void> revokeLocationPermission() async {
    await _storage.delete(key: _keyLocationPermission);
  }

  Future<bool> isLocationPermissionGranted() async {
    final value = await _storage.read(key: _keyLocationPermission);
    return value == 'true';
  }

  Future<bool> checkActualLocationPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await revokeLocationPermission();
        return false;
      }

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        await saveLocationPermissionGranted();
        return true;
      }

      await revokeLocationPermission();
      return false;
    } catch (e) {
      await revokeLocationPermission();
      return false;
    }
  }

  Future<void> saveNotificationPermissionGranted() async {
    await _storage.write(key: _keyNotificationPermission, value: 'true');
  }

  Future<void> revokeNotificationPermission() async {
    await _storage.delete(key: _keyNotificationPermission);
  }

  Future<bool> isNotificationPermissionGranted() async {
    final value = await _storage.read(key: _keyNotificationPermission);
    return value == 'true';
  }

  Future<bool> checkActualNotificationPermission() async {
    try {
      final settings = await FirebaseMessaging.instance
          .getNotificationSettings();
      final authorized =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      if (authorized) {
        await saveNotificationPermissionGranted();
        return true;
      }

      await revokeNotificationPermission();
      return false;
    } catch (e) {
      await revokeNotificationPermission();
      return false;
    }
  }

  Future<void> saveDarkMode(bool isDark) async {
    await _storage.write(key: _keyDarkMode, value: isDark ? 'true' : 'false');
  }

  Future<bool?> isDarkMode() async {
    final value = await _storage.read(key: _keyDarkMode);
    if (value == null) return null;
    return value == 'true';
  }

  Future<void> clearAll() => _storage.deleteAll();
}
