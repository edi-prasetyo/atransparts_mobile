import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/product_model.dart';

class ProductPriceSection extends StatelessWidget {
  final ProductModel product;

  const ProductPriceSection({super.key, required this.product});

  String _formatPrice(int price) {
    final text = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final reverseIndex = text.length - i;
      buffer.write(text[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) buffer.write('.');
    }
    return 'Rp$buffer';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final discount = product.oldPrice != null
        ? (((product.oldPrice! - product.price) / product.oldPrice!) * 100)
            .round()
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.oldPrice != null) ...[
                  Row(
                    children: [
                      Text(
                        _formatPrice(product.oldPrice!),
                        style: TextStyle(
                          fontSize: 13,
                          decoration: TextDecoration.lineThrough,
                          color: isDark ? AppColors.muted : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '-$discount%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  _formatPrice(product.price),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
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