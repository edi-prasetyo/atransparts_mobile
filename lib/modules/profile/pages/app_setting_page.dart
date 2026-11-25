import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';

class AppSettingPage extends ConsumerWidget {
  const AppSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final darkModeAsync = ref.watch(darkModeProvider);
    final isDarkMode = darkModeAsync.value ?? false;

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'Pengaturan Aplikasi',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SwitchListTile(
              value: isDarkMode,
              onChanged: (value) => ref.read(darkModeProvider.notifier).set(value),
              secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
              title: const Text(
                'Mode Gelap',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Ubah tampilan aplikasi ke mode gelap',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.muted : Colors.grey[600],
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}