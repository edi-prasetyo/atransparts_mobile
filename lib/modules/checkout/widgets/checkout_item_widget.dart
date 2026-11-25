import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/checkout_model.dart';

class CheckoutItemWidget extends StatelessWidget {
  final CheckoutItem item;

  const CheckoutItemWidget({
    super.key,
    required this.item,
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: isDark
                  ? Colors.grey.withValues(alpha: 0.08)
                  : const Color(0xFFF4F6F8),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    Icons.construction_rounded,
                    size: 24,
                    color: AppColors.primary.withValues(alpha: 0.65),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 1.2,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.brand,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.quantity}x ${_formatPrice(item.price)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.muted : Colors.grey[600],
                      ),
                    ),
                    Text(
                      _formatPrice(item.subtotal),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}