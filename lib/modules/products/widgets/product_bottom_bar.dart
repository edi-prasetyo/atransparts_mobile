import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProductBottomBar extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductBottomBar({
    super.key,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.muted.withValues(alpha: 0.2)
                : AppColors.divider,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onAddToCart,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
              label: const Text(
                'Keranjang',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.icon(
              onPressed: onBuyNow,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.flash_on_rounded, size: 18),
              label: const Text(
                'Beli Sekarang',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}