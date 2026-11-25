import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      // Router harus re-evaluasi berapapun isLoggedIn ATAU isVerified
      // berubah (mis. OTP diverifikasi / akun di-aktifkan lewat DB).
      if (previous?.isLoggedIn != next.isLoggedIn ||
          previous?.isVerified != next.isVerified) {
        notifyListeners();
      }
    });
  }
}

final routerRefreshNotifierProvider = Provider<ChangeNotifier>((ref) {
  return _RouterRefreshNotifier(ref);
});
