import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CategoryDetailHelpPage extends StatelessWidget {
  final int categoryId;

  const CategoryDetailHelpPage({super.key, required this.categoryId});

  List<_Faq> _faqsForCategory(int id) {
    switch (id) {
      case 1:
        return const [
          _Faq(
            'Bagaimana cara memesan produk?',
            'Pilih produk yang Anda inginkan, tambahkan ke keranjang, lalu lanjutkan ke checkout dan isi alamat pengiriman.',
          ),
          _Faq(
            'Bisakah saya membatalkan pesanan?',
            'Pesanan dapat dibatalkan selama masih berstatus pending dan belum dibayar.',
          ),
        ];
      case 2:
        return const [
          _Faq(
            'Metode pembayaran apa saja yang tersedia?',
            'Kami menyediakan Virtual Account (BCA, Mandiri, BNI, BRI), e-wallet (GoPay, OVO, DANA), dan kartu kredit.',
          ),
          _Faq(
            'Berapa lama batas waktu pembayaran?',
            'Pembayaran harus diselesaikan dalam 24 jam setelah pesanan dibuat.',
          ),
        ];
      case 3:
        return const [
          _Faq(
            'Berapa lama pengiriman?',
            'Estimasi pengiriman 1-3 hari kerja tergantung lokasi Anda.',
          ),
          _Faq(
            'Apakah ada biaya pengiriman?',
            'Biaya pengiriman dihitung berdasarkan lokasi tujuan dan berat paket.',
          ),
        ];
      case 4:
        return const [
          _Faq(
            'Bagaimana cara mengembalikan produk?',
            'Ajukan pengembalian melalui menu bantuan dengan menyertakan nomor pesanan dan alasan pengembalian.',
          ),
          _Faq(
            'Berapa lama proses pengembalian?',
            'Proses pengembalian dan refund memakan waktu 3-7 hari kerja.',
          ),
        ];
      default:
        return const [
          _Faq(
            'Bagaimana cara mengubah data akun?',
            'Buka halaman profil dan pilih menu yang sesuai untuk mengubah data akun Anda.',
          ),
          _Faq(
            'Bagaimana jika lupa kata sandi?',
            'Gunakan fitur "Lupa Kata Sandi" di halaman login untuk mereset kata sandi.',
          ),
        ];
    }
  }

  String _categoryTitle(int id) {
    switch (id) {
      case 1:
        return 'Pemesanan';
      case 2:
        return 'Pembayaran';
      case 3:
        return 'Pengiriman';
      case 4:
        return 'Pengembalian';
      default:
        return 'Akun';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final faqs = _faqsForCategory(categoryId);

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: Text(
          _categoryTitle(categoryId),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: faqs
            .map(
              (faq) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.help_outline_rounded, size: 14, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            faq.question,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      faq.answer,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: isDark ? AppColors.muted : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Faq {
  final String question;
  final String answer;

  const _Faq(this.question, this.answer);
}