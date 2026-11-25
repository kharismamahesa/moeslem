import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'app_text.dart';

enum AppButtonVariant { filled, outlined, soft }

class AppButton extends StatelessWidget {
  const AppButton(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.variant = AppButtonVariant.filled,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final AppButtonVariant variant;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.dark,
            ),
          )
        else if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        AppText(
          label,
          style: AppTextStyle.labelLarge,
          color: AppColors.dark,
        ),
      ],
    );

    final enabled = onPressed != null && !loading;
    final action = enabled ? onPressed : null;

    return switch (variant) {
      AppButtonVariant.filled => FilledButton(
          onPressed: action,
          child: child,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: action,
          child: child,
        ),
      AppButtonVariant.soft => TextButton(
          onPressed: action,
          style: TextButton.styleFrom(
            backgroundColor: AppColors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: child,
        ),
    };
  }
}
