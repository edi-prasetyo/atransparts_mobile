import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/home_model.dart';

class HomePromoCard extends StatelessWidget {
  final HomePromotion promotion;
  final VoidCallback onPressed;

  const HomePromoCard({
    super.key,
    required this.promotion,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [promotion.startColor, promotion.endColor],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promotion.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  promotion.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    promotion.buttonLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.construction_outlined,
              size: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
