import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_router.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/payment_controller.dart';
import '../models/payment_model.dart';
import '../widgets/payment_detail_card.dart';
import '../widgets/payment_instructions_widget.dart';
import '../widgets/payment_timer_widget.dart';

class PayPage extends ConsumerWidget {
  const PayPage({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paymentDetail = ref.watch(paymentDetailProvider);

    if (paymentDetail == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pembayaran')),
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
                'Metode pembayaran tidak ditemukan',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.muted : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go(AppRoutes.products),
                child: const Text('Kembali Belanja'),
              ),
            ],
          ),
        ),
      );
    }

    final isVa = paymentDetail.paymentMethodId.contains('_va');
    final method = availablePaymentMethods.firstWhere(
      (m) => m.id == paymentDetail.paymentMethodId,
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'Pembayaran',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              children: [
                PaymentTimerWidget(
                  expiredAt: paymentDetail.expiredAt,
                  onExpired: () {
                    _showMessage(context, 'Waktu pembayaran telah habis');
                  },
                ),
                const SizedBox(height: 16),
                if (isVa) ...[
                  PaymentDetailCard(
                    vaNumber: paymentDetail.vaNumber!,
                    totalAmount: paymentDetail.totalAmount,
                    onCopy: () {
                      Clipboard.setData(
                        ClipboardData(text: paymentDetail.vaNumber!),
                      );
                      _showMessage(context, 'Nomor VA disalin');
                    },
                  ),
                ] else ...[
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
                          'Kode Pembayaran',
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
                                paymentDetail.billCode!,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                  color: isDark ? Colors.white : AppColors.ink,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: paymentDetail.billCode!),
                                );
                                _showMessage(context, 'Kode pembayaran disalin');
                              },
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
                              'Metode',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.muted
                                    : Colors.grey[600],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  method.icon,
                                  size: 16,
                                  color: method.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  paymentDetail.paymentMethodName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Pembayaran',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.muted
                                    : Colors.grey[600],
                              ),
                            ),
                            Text(
                              _formatPrice(paymentDetail.totalAmount),
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
                  ),
                ],
                const SizedBox(height: 16),
                PaymentInstructionsWidget(
                  paymentMethodName: paymentDetail.paymentMethodName,
                ),
                const SizedBox(height: 16),
                _buildRincianWidget(context, ref, isDark),
                const SizedBox(height: 24),
              ],
            ),
          ),
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
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Kembali',
                      variant: CustomButtonVariant.outline,
                      onPressed: () {
                        context.pop();
                        context.pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: 'Cek Status',
                      onPressed: () {
                        _showMessage(context, 'Memeriksa status pembayaran...');
                        // Navigate to orders after successful payment
                        Future.delayed(const Duration(seconds: 2), () {
                          if (context.mounted) {
                            context.go(AppRoutes.orders);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRincianWidget(BuildContext context, WidgetRef ref, bool isDark) {
    final paymentDetail = ref.watch(paymentDetailProvider)!;

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
            'Rincian Pembayaran',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          _buildRow(
            label: 'Subtotal',
            value: _formatPrice(paymentDetail.amount),
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildRow(
            label: 'Biaya Admin',
            value: _formatPrice(paymentDetail.adminFee),
            isDark: isDark,
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
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
              ),
              Text(
                _formatPrice(paymentDetail.totalAmount),
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
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    required bool isDark,
  }) {
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
}