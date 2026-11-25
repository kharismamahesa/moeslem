import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../data/models/surah.dart';

class SurahTile extends StatelessWidget {
  const SurahTile({
    super.key,
    required this.surah,
    required this.bookmarked,
    required this.onTap,
    required this.onToggleBookmark,
  });

  final Surah surah;
  final bool bookmarked;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) => AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppText(
                  '${surah.number}',
                  style: AppTextStyle.caption,
                  weight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(surah.englishName, style: AppTextStyle.subtitle),
                  const SizedBox(height: 2),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: AppText(
                      surah.arabicName,
                      style: AppTextStyle.caption,
                      color: AppColors.muted,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppChip(
                    label: '${surah.revelationLabel} • ${surah.ayahCount} ayat',
                  ),
                ],
              ),
            ),
            AppIconButton(
              icon: bookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              active: bookmarked,
              tooltip: bookmarked ? 'Hapus bookmark' : 'Simpan bookmark',
              onPressed: onToggleBookmark,
            ),
          ],
        ),
      );
}
