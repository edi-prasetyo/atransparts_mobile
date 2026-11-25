import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_router.dart';
import '../../../core/widgets/custom_button.dart';
import '../../orders/models/order_model.dart';
import '../../orders/widgets/order_detail_item_widget.dart';
import '../../payment/controllers/payment_controller.dart';
import '../controllers/bill_controller.dart';
import '../models/bill_model.dart';

class DetailBillPage extends ConsumerWidget {
  final int billId;

  const DetailBillPage({super.key, required this.billId});

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
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$minute';
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bill = ref.watch(billDetailProvider(billId));

    if (bill == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tagihan')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: AppColors.muted),
              const SizedBox(height: 8),
              Text(
                'Tagihan tidak ditemukan',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.muted : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'Detail Tagihan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
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
                            bill.billNumber,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.ink,
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
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _getStatusColor(bill.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _infoRow(Icons.calendar_today_rounded, 'Tanggal Terbit', _formatDate(bill.issuedAt), isDark),
                      _infoRow(Icons.event_rounded, 'Jatuh Tempo', _formatDate(bill.dueDate), isDark),
                      if (bill.paidAt != null)
                        _infoRow(Icons.check_circle_rounded, 'Dibayar', _formatDate(bill.paidAt!), isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Produk (${bill.items.length})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...bill.items.map(
                        (item) => OrderDetailItemWidget(
                          item: _toOrderItem(item),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _buildRow('Subtotal', _formatPrice(bill.subtotal), isDark),
                      const SizedBox(height: 8),
                      _buildRow('Biaya Admin', _formatPrice(bill.adminFee), isDark),
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
                            'Total Tagihan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.ink,
                            ),
                          ),
                          Text(
                            _formatPrice(bill.total),
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
                ),
                if (bill.status == BillStatus.overdue) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.danger),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tagihan ini sudah melewati tanggal jatuh tempo. Segera lakukan pembayaran.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white : AppColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (bill.canPay)
            Container(
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
                child: CustomButton(
                  text: 'Bayar Sekarang',
                  prefixIcon: Icons.payment_rounded,
                  onPressed: () {
                    ref.read(billPaymentProvider.notifier).state = bill;
                    context.push(AppRoutes.selectPayment);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isDark ? AppColors.muted : Colors.grey[600]),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
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

  Widget _buildRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.muted : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
      ],
    );
  }

  OrderItem _toOrderItem(BillItem item) {
    return OrderItem(
      productId: item.productId,
      productName: item.productName,
      brand: item.brand,
      imageUrl: item.imageUrl,
      price: item.price,
      quantity: item.quantity,
      subtotal: item.subtotal,
    );
  }
}