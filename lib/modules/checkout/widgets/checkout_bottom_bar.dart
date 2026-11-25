import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';

class CheckoutBottomBar extends StatelessWidget {
  final int totalPrice;
  final VoidCallback onCheckout;

  const CheckoutBottomBar({
    super.key,
    required this.totalPrice,
    required this.onCheckout,
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.muted : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatPrice(totalPrice),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            CustomButton(
              text: 'Buat Pesanan',
              isExpanded: false,
              onPressed: onCheckout,
              suffixIcon: Icons.arrow_forward_rounded,
            ),
          ],
        ),
      ),
    );
  }
}