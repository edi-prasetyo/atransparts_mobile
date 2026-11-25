import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

import '../theme/app_colors.dart';

class PaymentWidget extends StatelessWidget {
  final Function(String method) onPaymentSelected;

  const PaymentWidget({super.key, required this.onPaymentSelected});

  @override
  Widget build(BuildContext context) {
    const colorTextSub = Color(0xFF64748B);

    // List pilihan metode pembayaran beserta icon dan deskripsinya
    final List<Map<String, dynamic>> paymentMethods = [
      {
        'id': 'point_balance',
        'title': 'Bayar Dengan Point',
        'subtitle': 'Pastikan Anda memiliki point yang cukup untuk booking',
        'icon': MingCuteIcons.mgc_coin_2_line,
        'iconColor': Colors.blue[700],
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : AppColors.fieldLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar Atas Bottom Sheet
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Silakan tentukan metode pembayaran tiket travel Anda',
              style: TextStyle(fontSize: 12, color: colorTextSub),
            ),
            const SizedBox(height: 16),

            // Render List Pilihan
            Column(
              children: paymentMethods.map((method) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.muted
                            : AppColors.grey,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () {
                          onPaymentSelected(method['id']);
                          Navigator.pop(context); // Tutup bottom sheet
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: method['iconColor'].withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  method['icon'],
                                  color: method['iconColor'],
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      method['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      method['subtitle'],
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: colorTextSub,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                MingCuteIcons.mgc_arrow_right_line,
                                color: colorTextSub,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
