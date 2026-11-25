import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/checkout_model.dart';

class CheckoutSummaryWidget extends StatelessWidget {
  final CheckoutSummary summary;

  const CheckoutSummaryWidget({
    super.key,
    required this.summary,
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
        children: [
          _buildRow(
            label: 'Subtotal',
            value: _formatPrice(summary.subtotal),
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildRow(
            label: 'Ongkos Kirim',
            value: _formatPrice(summary.shippingCost),
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildRow(
            label: 'Diskon',
            value: '-${_formatPrice(summary.discount)}',
            isDark: isDark,
            valueColor: summary.discount > 0 ? AppColors.success : null,
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: isDark ? AppColors.muted.withValues(alpha: 0.2) : AppColors.divider,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
              ),
              Text(
                _formatPrice(summary.total),
                style: const TextStyle(
                  fontSize: 20,
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

  Widget _buildRow({
    required String label,
    required String value,
    required bool isDark,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.muted : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? Colors.white : AppColors.ink),
          ),
        ),
      ],
    );
  }
}