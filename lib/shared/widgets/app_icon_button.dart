import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.active = false,
    this.onDark = false,
    this.size = 38,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool active;
  final bool onDark;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = switch ((active, onDark)) {
      (true, _) => AppColors.lime,
      (false, true) => AppColors.white,
      (false, false) => AppColors.dark,
    };
    final background = switch ((active, onDark)) {
      (true, true) => AppColors.white.withValues(alpha: 0.18),
      (true, false) => AppColors.lime.withValues(alpha: 0.22),
      (false, true) => AppColors.white.withValues(alpha: 0.12),
      (false, false) => AppColors.white,
    };

    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: size * 0.52, color: color),
        ),
      ),
    );
  }
}
