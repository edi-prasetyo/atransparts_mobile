import 'package:material_ui/material_ui.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const HomeSectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF14162B),
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'Lihat Semua',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}
