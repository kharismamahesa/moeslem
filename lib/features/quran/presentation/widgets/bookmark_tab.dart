import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_feedback.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../providers/quran_provider.dart';
import '../screens/surah_detail_screen.dart';
import 'surah_tile.dart';

class BookmarkTab extends StatelessWidget {
  const BookmarkTab({
    super.key,
    required this.quran,
    required this.onOpenSurah,
  });

  final QuranProvider quran;
  final OpenSurahCallback onOpenSurah;

  @override
  Widget build(BuildContext context) {
    final surahs = quran.bookmarkedSurahs;
    final ayahs = quran.bookmarkedAyahs;

    if (surahs.isEmpty && ayahs.isEmpty) {
      return const AppEmptyView(
        icon: Icons.bookmark_border_rounded,
        title: 'Belum ada bookmark',
        message: 'Tekan ikon bookmark pada surah atau ayat untuk menyimpannya di sini.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        if (surahs.isNotEmpty) ...[
          AppText('Surah tersimpan', style: AppTextStyle.title),
          const SizedBox(height: 10),
          ...surahs.map(
            (surah) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SurahTile(
                surah: surah,
                bookmarked: true,
                onTap: () => onOpenSurah(surah.number, surah.englishName),
                onToggleBookmark: () => quran.toggleBookmark(surah.number),
              ),
            ),
          ),
        ],
        if (ayahs.isNotEmpty) ...[
          const SizedBox(height: 12),
          AppText('Ayat tersimpan', style: AppTextStyle.title),
          const SizedBox(height: 10),
          ...ayahs.map((entry) {
            final name = quran.surahName(entry.surahNumber);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                onTap: () => onOpenSurah(
                  entry.surahNumber,
                  name,
                  ayahNumber: entry.ayahNumber,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bookmark_rounded,
                          size: 18, color: AppColors.dark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(name, style: AppTextStyle.subtitle),
                          AppText('Ayat ${entry.ayahNumber}',
                              style: AppTextStyle.caption,
                              color: AppColors.muted),
                        ],
                      ),
                    ),
                    AppIconButton(
                      icon: Icons.delete_outline_rounded,
                      tooltip: 'Hapus bookmark',
                      onPressed: () => quran
                          .toggleAyahBookmark(entry.surahNumber, entry.ayahNumber),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}
