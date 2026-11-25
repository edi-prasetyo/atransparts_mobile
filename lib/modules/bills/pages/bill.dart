import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/bill_controller.dart';
import '../models/bill_model.dart';

class BillPage extends ConsumerWidget {
  const BillPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bills = ref.watch(billsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'Tagihan Saya',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: bills.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Belum ada tagihan',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.muted : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: bills.length,
              itemBuilder: (context, index) {
                final bill = bills[index];
                return _BillCard(
                  bill: bill,
                  onTap: () => context.push('/bills/detail/${bill.id}'),
                );
              },
            ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final BillModel bill;
  final VoidCallback onTap;

  const _BillCard({required this.bill, required this.onTap});

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

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _getStatusColor(BillStatus status) {
    switch (status) {
      case BillStatus.unpaid:
        return AppColors.primary;
      case BillStatus.dueSoon:
        return AppColors.warning;
      case BillStatus.overdue:
        return AppColors.danger;
      case BillStatus.paid:
        return AppColors.success;
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: bill.status == BillStatus.overdue
              ? Border.all(color: AppColors.danger.withValues(alpha: 0.4))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bill.billNumber,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.muted : Colors.grey[600],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(bill.status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    bill.statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _getStatusColor(bill.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: isDark ? AppColors.muted : Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'Jatuh tempo: ${_formatDate(bill.dueDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.muted : Colors.grey[600],
                  ),
                ),
                if (bill.status != BillStatus.paid) ...[
                  const Spacer(),
                  Text(
                    _dueLabel(bill),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(bill.status),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 1,
              color: isDark ? AppColors.muted.withValues(alpha: 0.2) : AppColors.divider,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${bill.items.length} produk',
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
                      _formatPrice(bill.total),
                      style: const TextStyle(
                        fontSize: 16,
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

  String _dueLabel(BillModel bill) {
    if (bill.status == BillStatus.overdue) {
      return 'Terlambat ${bill.daysUntilDue.abs()} hari';
    }
    if (bill.daysUntilDue == 0) return 'Jatuh tempo hari ini';
    return '${bill.daysUntilDue} hari lagi';
  }
}