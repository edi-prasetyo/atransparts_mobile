import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'Info Aplikasi',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.construction_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Atran Parts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Versi 1.0.0',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.muted : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tentang Aplikasi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Atran Parts adalah aplikasi belanja sparepart kendaraan yang menyediakan berbagai kebutuhan suku cadang berkualitas dengan harga terjangkau.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: isDark ? AppColors.muted : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}