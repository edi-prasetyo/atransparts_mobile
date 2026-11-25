import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class OrderDetailInfoWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const OrderDetailInfoWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? AppColors.muted : Colors.grey[600],
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.muted : Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}