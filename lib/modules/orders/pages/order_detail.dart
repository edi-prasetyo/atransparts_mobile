import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';
import '../widgets/order_detail_item_widget.dart';
import '../widgets/order_detail_info_widget.dart';
import '../widgets/order_status_stepper.dart';

class OrderDetailPage extends ConsumerWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final order = ref.watch(orderDetailProvider(orderId));

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Pesanan')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.muted,
              ),
              const SizedBox(height: 8),
              Text(
                'Pesanan tidak ditemukan',
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
          'Detail Pesanan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
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
                      order.orderNumber,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.ink,
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
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _getStatusColor(order.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(order.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.muted : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OrderStatusStepper(
            createdAt: order.createdAt,
            paidAt: order.paidAt,
            shippedAt: order.shippedAt,
            deliveredAt: order.deliveredAt,
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
                  'Produk Dipesan (${order.items.length})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 12),
                ...order.items.map(
                  (item) => OrderDetailItemWidget(item: item),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Pengiriman',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                OrderDetailInfoWidget(
                  icon: Icons.location_on_rounded,
                  label: 'Alamat',
                  value: order.shippingAddress,
                ),
                OrderDetailInfoWidget(
                  icon: Icons.payment_rounded,
                  label: 'Metode Bayar',
                  value: order.paymentMethod,
                ),
                if (order.paymentVaNumber != null)
                  OrderDetailInfoWidget(
                    icon: Icons.account_balance_rounded,
                    label: 'No. VA',
                    value: order.paymentVaNumber!,
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
                _buildRow('Subtotal', _formatPrice(order.subtotal), isDark),
                const SizedBox(height: 8),
                _buildRow('Ongkos Kirim', _formatPrice(order.shippingCost), isDark),
                const SizedBox(height: 8),
                _buildRow('Biaya Admin', _formatPrice(order.adminFee), isDark),
                const SizedBox(height: 8),
                _buildRow('Diskon', '-${_formatPrice(order.discount)}', isDark),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.ink,
                      ),
                    ),
                    Text(
                      _formatPrice(order.total),
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
          ),
          if (order.status == OrderStatus.pending) ...[
            const SizedBox(height: 16),
            CustomButton(
              text: 'Bayar Sekarang',
              onPressed: () {
                context.push('/pay');
              },
            ),
          ],
          if (order.status == OrderStatus.delivered) ...[
            const SizedBox(height: 16),
            CustomButton(
              text: 'Pesanan Diterima',
              variant: CustomButtonVariant.success,
              onPressed: () {
                // Simulate marking as received
              },
            ),
          ],
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