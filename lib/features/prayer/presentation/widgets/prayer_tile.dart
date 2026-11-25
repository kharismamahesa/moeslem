import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../data/models/prayer_times.dart';

class PrayerTile extends StatelessWidget {
  const PrayerTile({super.key, required this.entry, required this.isNext});

  final PrayerEntry entry;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.surface,
      borderColor: isNext ? AppColors.lime : AppColors.border,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(entry.icon, size: 20, color: AppColors.dark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(entry.label, style: AppTextStyle.subtitle),
                if (isNext)
                  AppText('Waktu berikutnya',
                      style: AppTextStyle.caption, color: AppColors.muted),
              ],
            ),
          ),
          AppText(
            entry.time,
            style: AppTextStyle.title,
            color: AppColors.dark,
          ),
        ],
      ),
    );
  }
}
