import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class OrderStatusStepper extends StatelessWidget {
  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;

  const OrderStatusStepper({
    super.key,
    required this.createdAt,
    this.paidAt,
    this.shippedAt,
    this.deliveredAt,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final steps = [
      _StepData('Pesanan Dibuat', createdAt, true),
      _StepData('Pembayaran', paidAt, paidAt != null),
      _StepData('Dikirim', shippedAt, shippedAt != null),
      _StepData('Diterima', deliveredAt, deliveredAt != null),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: steps.map((step) => _buildStep(context, step, isDark)).toList(),
      ),
    );
  }

  Widget _buildStep(BuildContext context, _StepData step, bool isDark) {
    final isActive = step.isCompleted;
    final isLast = step == _lastStep;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isLast)
          Container(
            width: 2,
            height: 32,
            color: isActive ? AppColors.primary : (isDark ? AppColors.muted.withValues(alpha: 0.2) : AppColors.divider),
            margin: const EdgeInsets.only(left: 9),
          )
        else
          const SizedBox(width: 20),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : (isDark ? AppColors.cardDark : AppColors.surface),
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.divider,
              width: 2,
            ),
          ),
          child: isActive
              ? const Icon(
                  Icons.check_rounded,
                  size: 12,
                  color: Colors.white,
                )
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? (isDark ? Colors.white : AppColors.ink)
                      : (isDark ? AppColors.muted : Colors.grey[600]),
                ),
              ),
              if (step.time != null)
                Text(
                  _formatDateTime(step.time!),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.muted : Colors.grey[600],
                  ),
                ),
              if (!isLast) const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  _StepData get _lastStep => _StepData('Diterima', deliveredAt, deliveredAt != null);

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}, $hour:$minute';
  }
}

class _StepData {
  final String title;
  final DateTime? time;
  final bool isCompleted;

  _StepData(this.title, this.time, this.isCompleted);
}