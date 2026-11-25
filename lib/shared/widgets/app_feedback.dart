import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'app_button.dart';
import 'app_text.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.lime),
            if (message != null) ...[
              const SizedBox(height: 14),
              AppText(message!, style: AppTextStyle.caption, color: AppColors.muted),
            ],
          ],
        ),
      );
}

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 44, color: AppColors.lime),
            const SizedBox(height: 12),
            AppText(
              message,
              align: TextAlign.center,
              style: AppTextStyle.body,
              color: AppColors.muted,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              AppButton('Coba lagi', onPressed: onRetry, expanded: false),
            ],
          ],
        ),
      );
}

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_rounded,
  });

  final String title;
  final String? message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 34, color: AppColors.dark),
            ),
            const SizedBox(height: 14),
            AppText(title, style: AppTextStyle.subtitle),
            if (message != null) ...[
              const SizedBox(height: 6),
              AppText(
                message!,
                align: TextAlign.center,
                style: AppTextStyle.caption,
                color: AppColors.muted,
              ),
            ],
          ],
        ),
      );
}
