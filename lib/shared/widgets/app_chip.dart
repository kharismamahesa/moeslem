import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'app_text.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.background = AppColors.white,
    this.foreground = AppColors.dark,
  });

  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: foreground),
              const SizedBox(width: 4),
            ],
            AppText(
              label,
              style: AppTextStyle.caption,
              color: foreground,
              weight: FontWeight.w700,
            ),
          ],
        ),
      );
}
