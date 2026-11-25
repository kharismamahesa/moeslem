import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../data/models/surah_detail.dart';

class AyahCard extends StatelessWidget {
  const AyahCard({
    super.key,
    required this.ayah,
    required this.bookmarked,
    required this.onToggleBookmark,
    this.highlighted = false,
  });

  final Ayah ayah;
  final bool bookmarked;
  final VoidCallback onToggleBookmark;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => AppCard(
        borderColor: highlighted ? AppColors.lime : AppColors.border,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppText(
                      '${ayah.numberInSurah}',
                      style: AppTextStyle.caption,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                AppIconButton(
                  icon: bookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  active: bookmarked,
                  size: 34,
                  tooltip: bookmarked ? 'Hapus bookmark' : 'Simpan ayat',
                  onPressed: onToggleBookmark,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                ayah.arabic,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 26,
                  height: 1.7,
                  color: AppColors.dark,
                ),
              ),
            ),
            const Divider(height: 24),
            AppText(ayah.translation, style: AppTextStyle.bodyMedium),
          ],
        ),
      );
}
