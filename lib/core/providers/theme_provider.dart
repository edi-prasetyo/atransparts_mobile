import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/secure_service.dart';

// ================= NOTIFIER FOR RIVERPOD 3 =================
class DarkModeNotifier extends AsyncNotifier<bool?> {
  @override
  Future<bool?> build() async {
    final storage = ref.read(secureStorageProvider);
    return await storage.isDarkMode();
  }

  Future<void> toggle() async {
    final current = state.value ?? false;
    await set(!current);
  }

  Future<void> set(bool value) async {
    final storage = ref.read(secureStorageProvider);
    await storage.saveDarkMode(value);
    state = AsyncData(value);
  }
}

// ================= PROVIDERS REGISTRATION =================
final darkModeProvider = AsyncNotifierProvider<DarkModeNotifier, bool?>(
  DarkModeNotifier.new,
);