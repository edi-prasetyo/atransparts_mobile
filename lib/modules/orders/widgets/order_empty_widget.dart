import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class OrderEmptyWidget extends StatelessWidget {
  final String message;
  final VoidCallback onStartShopping;

  const OrderEmptyWidget({
    super.key,
    required this.message,
    required this.onStartShopping,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onStartShopping,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Belanja Sekarang',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}