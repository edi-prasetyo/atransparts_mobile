import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PaymentInstructionsWidget extends StatelessWidget {
  final String paymentMethodName;

  const PaymentInstructionsWidget({
    super.key,
    required this.paymentMethodName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isVa = paymentMethodName.contains('Virtual Account');
    final instructions = isVa ? _getVaInstructions(paymentMethodName) : _getEwalletInstructions(paymentMethodName);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Cara Pembayaran',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...instructions.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: isDark ? AppColors.muted : Colors.grey[700],
                      ),
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

  List<String> _getVaInstructions(String methodName) {
    final bankName = methodName.replaceAll(' Virtual Account', '');
    return [
      'Buka aplikasi mobile banking $bankName',
      'Pilih menu "Transfer" atau "Virtual Account"',
      'Masukkan nomor Virtual Account di atas',
      'Periksa detail pembayaran dan konfirmasi',
      'Selesaikan pembayaran',
    ];
  }

  List<String> _getEwalletInstructions(String methodName) {
    return [
      'Buka aplikasi $methodName',
      'Pilih menu "Kirim Uang" atau "Bayar"',
      'Scan QR Code atau masukkan kode pembayaran',
      'Periksa detail pembayaran dan konfirmasi',
      'Selesaikan pembayaran',
    ];
  }
}