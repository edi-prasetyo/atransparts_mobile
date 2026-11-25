import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProductFilterBar extends StatelessWidget {
  final String? selectedCategory;
  final String? selectedBrand;
  final VoidCallback onFilterTap;

  const ProductFilterBar({
    super.key,
    this.selectedCategory,
    this.selectedBrand,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _buildChip(
            icon: Icons.tune_rounded,
            label: selectedCategory ?? 'Kategori',
            isActive: selectedCategory != null,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildChip(
            icon: Icons.branding_watermark_rounded,
            label: selectedBrand ?? 'Brand',
            isActive: selectedBrand != null,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onFilterTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : (isDark ? AppColors.cardDark : AppColors.surface),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? AppColors.primary : AppColors.muted,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? AppColors.primary
                      : (isDark ? Colors.white : AppColors.ink),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}