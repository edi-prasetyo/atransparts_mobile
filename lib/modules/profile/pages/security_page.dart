import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      _SecurityItem(
        icon: Icons.password_rounded,
        title: 'Kata Sandi',
        subtitle: 'Kelola kata sandi akun Anda',
      ),
      _SecurityItem(
        icon: Icons.phone_android_rounded,
        title: 'Nomor Telepon',
        subtitle: 'Kelola nomor telepon terverifikasi',
      ),
      _SecurityItem(
        icon: Icons.email_rounded,
        title: 'Email',
        subtitle: 'Kelola alamat email terverifikasi',
      ),
      _SecurityItem(
        icon: Icons.fingerprint_rounded,
        title: 'Biometrik',
        subtitle: 'Aktifkan sidik jari / face unlock',
      ),
      _SecurityItem(
        icon: Icons.devices_rounded,
        title: 'Perangkat Aktif',
        subtitle: 'Lihat perangkat yang login ke akun',
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'Keamanan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: items.asMap().entries.map((entry) {
            final item = entry.value;
            final isLast = entry.key == items.length - 1;
            return Column(
              children: [
                ListTile(
                  leading: Icon(item.icon, color: AppColors.primary),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : AppColors.ink,
                    ),
                  ),
                  subtitle: Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.muted : Colors.grey[600],
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? AppColors.muted : Colors.grey[400],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 16,
                    color: isDark ? AppColors.muted.withValues(alpha: 0.15) : AppColors.divider,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SecurityItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SecurityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}