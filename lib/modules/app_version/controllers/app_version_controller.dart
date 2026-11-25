import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/services/public_service.dart';
import '../models/app_version_model.dart';

final appVersionControllerProvider =
    AsyncNotifierProvider<AppVersionController, AppVersionResponse?>(() {
  return AppVersionController();
});

class AppVersionController extends AsyncNotifier<AppVersionResponse?> {
  @override
  Future<AppVersionResponse?> build() async {
    return checkVersion();
  }

  String _platform() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
  }

  Future<AppVersionResponse?> checkVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final request = AppVersionRequest(
        platform: _platform(),
        type: 'customer',
        version: info.version,
        code: info.buildNumber,
      );

      final dio = ref.read(publicProvider);
      final response = await dio.get(
        '/app-version/check',
        queryParameters: request.toParams(),
      );

      debugPrint('APP_VERSION CHECK data: ${request.toParams()}');
      debugPrint('APP_VERSION CHECK response: ${response.data}');

      return AppVersionResponse.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } catch (e) {
      debugPrint('DEBUG: [APP_VERSION_CHECK] Gagal: $e');
      rethrow;
    }
  }
}
