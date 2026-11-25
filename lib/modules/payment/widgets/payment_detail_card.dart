import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PaymentDetailCard extends StatelessWidget {
  final String vaNumber;
  final int totalAmount;
  final VoidCallback onCopy;

  const PaymentDetailCard({
    super.key,
    required this.vaNumber,
    required this.totalAmount,
    required this.onCopy,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nomor Virtual Account',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.muted : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  vaNumber,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
              ),
              InkWell(
                onTap: onCopy,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.copy_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: isDark
                ? AppColors.muted.withValues(alpha: 0.2)
                : AppColors.divider,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.muted : Colors.grey[600],
                ),
              ),
              Text(
                _formatPrice(totalAmount),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}