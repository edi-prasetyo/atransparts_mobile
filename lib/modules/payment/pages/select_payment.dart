import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_router.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/payment_controller.dart';
import '../models/payment_model.dart';
import '../widgets/payment_method_item.dart';

class SelectPaymentPage extends ConsumerWidget {
  const SelectPaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedMethod = ref.watch(selectedPaymentMethodProvider);
    final total = ref.watch(paymentAmountProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'Pilih Pembayaran',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.muted : Colors.grey[600],
                        ),
                      ),
                      Text(
                        _formatPrice(total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                ...availablePaymentMethods.map(
                  (method) => PaymentMethodItem(
                    method: method,
                    isSelected: selectedMethod?.id == method.id,
                    onTap: () {
                      ref.read(selectedPaymentMethodProvider.notifier).state = method;
                    },
                  ),
                ),
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
              child: CustomButton(
                text: 'Lanjutkan',
                onPressed: selectedMethod == null
                    ? null
                    : () {
                        context.push(AppRoutes.pay);
                      },
              ),
            ),
          ),
        ],
      ),
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