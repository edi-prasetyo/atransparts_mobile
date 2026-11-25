import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class TermPage extends StatelessWidget {
  const TermPage({super.key});

  static const _content = [
    ('Syarat & Ketentuan', true),
    ('Dengan menggunakan aplikasi Atran Parts, Anda menyetujui syarat dan ketentuan berikut.', false),
    ('1. Penggunaan Layanan', true),
    ('Anda harus menggunakan layanan ini hanya untuk tujuan yang sah. Anda bertanggung jawab untuk menjaga kerahasiaan akun dan kata sandi Anda.', false),
    ('2. Pemesanan & Pembayaran', true),
    ('Semua pesanan tunduk pada ketersediaan produk. Pembayaran harus dilakukan sesuai dengan metode yang tersedia dan batas waktu yang ditentukan.', false),
    ('3. Pengembalian', true),
    ('Pengembalian produk dapat dilakukan sesuai dengan kebijakan pengembalian yang berlaku dan dalam kondisi produk yang masih layak jual.', false),
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
          'Syarat & Ketentuan',
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