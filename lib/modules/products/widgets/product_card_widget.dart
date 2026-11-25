import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

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

    return Material(
      color: isDark ? AppColors.cardDark : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: isDark
                        ? Colors.grey.withValues(alpha: 0.08)
                        : const Color(0xFFF4F6F8),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.construction_rounded,
                          size: 48,
                          color: AppColors.primary.withValues(alpha: 0.65),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.brand,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.2,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${product.rating}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.muted : Colors.grey,
                        ),
                      ),
                      Text(
                        '  •  ${product.sold} terjual',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.muted : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  if (product.oldPrice != null)
                    Text(
                      _formatPrice(product.oldPrice!),
                      style: TextStyle(
                        fontSize: 9,
                        decoration: TextDecoration.lineThrough,
                        color: isDark ? AppColors.muted : Colors.grey,
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatPrice(product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onAddToCart,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}