import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class CategoryHelpPage extends StatelessWidget {
  const CategoryHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      _HelpCategory(
        id: 1,
        icon: Icons.shopping_bag_outlined,
        title: 'Pemesanan',
        description: 'Cara memesan produk',
      ),
      _HelpCategory(
        id: 2,
        icon: Icons.payment_rounded,
        title: 'Pembayaran',
        description: 'Metode dan cara pembayaran',
      ),
      _HelpCategory(
        id: 3,
        icon: Icons.local_shipping_outlined,
        title: 'Pengiriman',
        description: 'Informasi pengiriman produk',
      ),
      _HelpCategory(
        id: 4,
        icon: Icons.assignment_return_outlined,
        title: 'Pengembalian',
        description: 'Cara mengembalikan produk',
      ),
      _HelpCategory(
        id: 5,
        icon: Icons.account_circle_outlined,
        title: 'Akun',
        description: 'Pengaturan akun dan keamanan',
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: categories
            .map(
              (category) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  onTap: () => context.push('/category-detail-help/${category.id}'),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(category.icon, color: AppColors.primary, size: 22),
                  ),
                  title: Text(
                    category.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.ink,
                    ),
                  ),
                  subtitle: Text(
                    category.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.muted : Colors.grey[600],
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? AppColors.muted : Colors.grey[400],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _HelpCategory {
  final int id;
  final IconData icon;
  final String title;
  final String description;

  const _HelpCategory({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
  });
}