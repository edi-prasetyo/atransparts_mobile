import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/network_service.dart';
import '../models/profile_model.dart';

/// Provider untuk mengambil data profil user yang sedang login.
/// Di-invalidate saat login/logout (lihat auth_controller).
final profileControllerProvider = FutureProvider<ProfileModel?>((ref) async {
  final dio = ref.watch(dioProvider);

  try {
    final response = await dio.get('/profile');
    final data = response.data;

    if (data is Map<String, dynamic>) {
      // Bisa dibungkus { "user": {...} } atau langsung objek user
      final user = data['user'] as Map<String, dynamic>? ?? data;
      return ProfileModel.fromJson(user);
    }
    return null;
  } catch (e) {
    return null;
  }
});