import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/checkout_model.dart';

class CheckoutAddressWidget extends StatelessWidget {
  final CheckoutAddress? address;
  final VoidCallback onEdit;

  const CheckoutAddressWidget({
    super.key,
    this.address,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: address == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alamat Pengiriman',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.muted : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tambahkan alamat pengiriman',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              address!.recipientName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.ink,
                              ),
                            ),
                          ),
                          Text(
                            address!.phoneNumber,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.muted : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${address!.address}, ${address!.city}, ${address!.province} ${address!.postalCode}',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: isDark ? AppColors.muted : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              address == null ? 'Tambah' : 'Ubah',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}