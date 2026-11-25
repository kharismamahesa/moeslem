import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/state/view_status.dart';
import '../../../../shared/widgets/app_feedback.dart';
import '../../../../shared/widgets/app_page_header.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/quran_provider.dart';
import '../widgets/bookmark_tab.dart';
import '../widgets/surah_tile.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSurah(int number, String name, {int? ayahNumber}) {
    Navigator.of(context).push(
      SurahDetailScreen.route(number, name, targetAyah: ayahNumber),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Alquran'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Daftar Surah', icon: Icon(Icons.list_rounded, size: 18)),
              Tab(text: 'Bookmark', icon: Icon(Icons.bookmark_rounded, size: 18)),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: AppPageHeader(
                icon: Icons.menu_book_rounded,
                title: 'Alquran',
                subtitle: 'Baca Alquran dan simpan surah atau ayat favoritmu.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppTextField(
                controller: _searchController,
                hint: 'Cari nama surah atau nomor',
                prefixIcon: Icons.search_rounded,
                textInputAction: TextInputAction.search,
                onChanged: quran.setQuery,
                suffixIcon: quran.query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          quran.setQuery('');
                        },
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: [
                  _SurahListTab(quran: quran, onOpenSurah: _openSurah),
                  BookmarkTab(quran: quran, onOpenSurah: _openSurah),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurahListTab extends StatelessWidget {
  const _SurahListTab({required this.quran, required this.onOpenSurah});

  final QuranProvider quran;
  final OpenSurahCallback onOpenSurah;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: quran.loadSurahs,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: switch (quran.status) {
            ViewStatus.loading => const [
                SizedBox(
                  height: 300,
                  child: AppLoading(message: 'Mengambil daftar surah...'),
                ),
              ],
            ViewStatus.error => [
                SizedBox(
                  height: 300,
                  child: AppErrorView(
                    message: quran.error ?? 'Gagal memuat data.',
                    onRetry: quran.loadSurahs,
                  ),
                ),
              ],
            _ => _buildItems(),
          },
        ),
      );

  List<Widget> _buildItems() {
    final surahs = quran.visibleSurahs;
    if (surahs.isEmpty) {
      return const [
        SizedBox(
          height: 300,
          child: AppEmptyView(
            icon: Icons.search_off_rounded,
            title: 'Surah tidak ditemukan',
            message: 'Coba kata kunci lain.',
          ),
        ),
      ];
    }

    return surahs
        .map(
          (surah) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SurahTile(
              surah: surah,
              bookmarked: quran.isBookmarked(surah.number),
              onTap: () => onOpenSurah(surah.number, surah.englishName),
              onToggleBookmark: () => quran.toggleBookmark(surah.number),
            ),
          ),
        )
        .toList();
  }
}
