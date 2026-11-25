import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  static const _content = [
    ('Kebijakan Privasi', true),
    ('Kami menghargai privasi Anda. Kebijakan ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi pribadi Anda.', false),
    ('1. Informasi yang Kami Kumpulkan', true),
    ('Kami mengumpulkan informasi yang Anda berikan secara langsung, seperti nama, alamat email, nomor telepon, dan alamat pengiriman saat Anda mendaftar atau melakukan transaksi.', false),
    ('2. Penggunaan Informasi', true),
    ('Informasi yang dikumpulkan digunakan untuk memproses pesanan, memberikan dukungan pelanggan, dan meningkatkan pengalaman belanja Anda.', false),
    ('3. Perlindungan Data', true),
    ('Kami menerapkan langkah keamanan yang sesuai untuk melindungi informasi pribadi Anda dari akses tidak sah atau pengungkapan.', false),
  ];

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
          'Kebijakan Privasi',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _content.map((section) {
            final isHeading = section.$2;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                section.$1,
                style: TextStyle(
                  fontSize: isHeading ? 14 : 13,
                  fontWeight: isHeading ? FontWeight.w700 : FontWeight.w400,
                  height: 1.5,
                  color: isHeading
                      ? (isDark ? Colors.white : AppColors.ink)
                      : (isDark ? AppColors.muted : Colors.grey[700]),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}