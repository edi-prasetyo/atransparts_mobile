import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/cart_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 80,
              height: 80,
              color: isDark
                  ? Colors.grey.withValues(alpha: 0.08)
                  : const Color(0xFFF4F6F8),
              child: Image.network(
                item.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    Icons.construction_rounded,
                    size: 28,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1.2,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: isDark ? AppColors.muted : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    item.product.brand,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatPrice(item.subtotal),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? AppColors.muted.withValues(alpha: 0.3)
                              : AppColors.divider,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildButton(
                            icon: Icons.remove_rounded,
                            onTap: onDecrement,
                            isDark: isDark,
                          ),
                          SizedBox(
                            width: 28,
                            child: Text(
                              '${item.quantity}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.ink,
                              ),
                            ),
                          ),
                          _buildButton(
                            icon: Icons.add_rounded,
                            onTap: onIncrement,
                            isDark: isDark,
                          ),
                        ],
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

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.muted.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),
      ),
    );
  }
}