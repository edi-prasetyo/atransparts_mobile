import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CartEmptyWidget extends StatelessWidget {
  final VoidCallback onStartShopping;

  const CartEmptyWidget({super.key, required this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Keranjang Anda kosong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk, mulai belanja dan tambahkan\nproduk favorit Anda ke keranjang',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: isDark ? AppColors.muted : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onStartShopping,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Mulai Belanja',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}