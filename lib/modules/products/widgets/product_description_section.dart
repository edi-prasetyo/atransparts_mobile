import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProductDescriptionSection extends StatelessWidget {
  final String? description;
  final List<String>? specifications;

  const ProductDescriptionSection({
    super.key,
    this.description,
    this.specifications,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deskripsi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        if (description != null && description!.isNotEmpty)
          Text(
            description!,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? AppColors.muted : Colors.grey[700],
            ),
          ),
        if (specifications != null && specifications!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Spesifikasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: specifications!
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 4,
                            child: Text(
                              '•',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }
}