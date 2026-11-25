import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/order_model.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.onTap,
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

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.delivered:
        return AppColors.primary;
      case OrderStatus.finished:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderNumber,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.muted : Colors.grey[600],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    order.statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...order.items.take(3).map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 36,
                        height: 36,
                        color: isDark
                            ? Colors.grey.withValues(alpha: 0.08)
                            : const Color(0xFFF4F6F8),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.construction_rounded,
                              size: 16,
                              color: AppColors.primary.withValues(alpha: 0.65),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                    ),
                    Text(
                      '${item.quantity}x',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.muted : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (order.items.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+${order.items.length - 3} produk lainnya',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.muted : Colors.grey[600],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              color: isDark ? AppColors.muted.withValues(alpha: 0.2) : AppColors.divider,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.items.length} produk',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.muted : Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Total: ',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.muted : Colors.grey[600],
                      ),
                    ),
                    Text(
                      _formatPrice(order.total),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}