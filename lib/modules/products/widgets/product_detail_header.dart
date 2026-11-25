import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/product_model.dart';

class ProductDetailHeader extends StatelessWidget {
  final ProductModel product;

  const ProductDetailHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey.withValues(alpha: 0.08)
                : const Color(0xFFF4F6F8),
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(
                Icons.construction_rounded,
                size: 64,
                color: AppColors.primary.withValues(alpha: 0.65),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                product.brand,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                product.category,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.star_rounded,
              size: 18,
              color: AppColors.warning,
            ),
            const SizedBox(width: 4),
            Text(
              '${product.rating}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.ink,
              ),
            ),
            Text(
              '  •  ${product.sold} terjual',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.muted : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}