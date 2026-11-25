import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/home_model.dart';

class HomeCategoryList extends StatelessWidget {
  final List<HomeCategory> categories;
  final ValueChanged<HomeCategory> onTap;

  const HomeCategoryList({
    super.key,
    required this.categories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () => onTap(category),
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 72,
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      category.icon,
                      size: 28,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
