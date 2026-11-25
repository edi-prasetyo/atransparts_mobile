import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class OrderTabBar extends StatelessWidget {
  final TabController tabController;
  final int pendingCount;
  final int deliveredCount;
  final int finishedCount;
  final int cancelledCount;

  const OrderTabBar({
    super.key,
    required this.tabController,
    required this.pendingCount,
    required this.deliveredCount,
    required this.finishedCount,
    required this.cancelledCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.cardDark : AppColors.surface,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
          insets: const EdgeInsets.symmetric(horizontal: 20),
        ),
        labelColor: AppColors.primary,
        unselectedLabelColor: isDark ? AppColors.muted : Colors.grey[600],
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          _buildTab('Pending', pendingCount),
          _buildTab('Dikirim', deliveredCount),
          _buildTab('Selesai', finishedCount),
          _buildTab('Batal', cancelledCount),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}