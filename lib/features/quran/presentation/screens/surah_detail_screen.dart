import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/state/view_status.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_feedback.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../data/models/surah_detail.dart';
import '../providers/quran_provider.dart';
import '../widgets/ayah_card.dart';

typedef OpenSurahCallback = void Function(
  int number,
  String name, {
  int? ayahNumber,
});

class SurahDetailScreen extends StatefulWidget {
  const SurahDetailScreen({
    super.key,
    required this.number,
    required this.name,
    this.targetAyah,
  });

  final int number;
  final String name;
  final int? targetAyah;

  static Route<void> route(int number, String name, {int? targetAyah}) =>
      MaterialPageRoute<void>(
        builder: (_) => SurahDetailScreen(
          number: number,
          name: name,
          targetAyah: targetAyah,
        ),
      );

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final _scrollController = ScrollController();
  final _targetKey = GlobalKey();
  bool _didScroll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<QuranProvider>().loadDetail(widget.number);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTarget() {
    final targetContext = _targetKey.currentContext;
    if (targetContext == null) return;

    Scrollable.ensureVisible(
      targetContext,
      alignment: 0.2,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();
    final detail = quran.isCurrentDetail(widget.number) ? quran.detail : null;
    final bookmarked = quran.isBookmarked(widget.number);

    if (detail != null && widget.targetAyah != null && !_didScroll) {
      _didScroll = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTarget());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AppIconButton(
              icon: bookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              active: bookmarked,
              onDark: true,
              tooltip: bookmarked ? 'Hapus bookmark' : 'Simpan surah',
              onPressed: () => quran.toggleBookmark(widget.number),
            ),
          ),
        ],
      ),
      body: switch (quran.detailStatus) {
        ViewStatus.loading => const AppLoading(message: 'Mengambil ayat...'),
        ViewStatus.error => AppErrorView(
            message: quran.detailError ?? 'Gagal memuat ayat.',
            onRetry: () => quran.loadDetail(widget.number),
          ),
        _ => detail == null
            ? const AppEmptyView(
                icon: Icons.menu_book_rounded,
                title: 'Ayat belum tersedia',
              )
            : _buildDetail(quran, detail),
      },
    );
  }

  Widget _buildDetail(QuranProvider quran, SurahDetail detail) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        AppCard(
          color: AppColors.dark,
          borderColor: AppColors.lime,
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  detail.arabicName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppColors.lime,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AppText(
                detail.name,
                style: AppTextStyle.subtitle,
                color: AppColors.white,
              ),
              const SizedBox(height: 12),
              AppChip(label: '${detail.ayahs.length} ayat'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...detail.ayahs.map((ayah) {
          final isTarget = ayah.numberInSurah == widget.targetAyah;
          return Padding(
            key: isTarget ? _targetKey : null,
            padding: const EdgeInsets.only(bottom: 12),
            child: AyahCard(
              ayah: ayah,
              bookmarked: quran.isAyahBookmarked(
                widget.number,
                ayah.numberInSurah,
              ),
              highlighted: isTarget,
              onToggleBookmark: () => quran.toggleAyahBookmark(
                widget.number,
                ayah.numberInSurah,
              ),
            ),
          );
        }),
      ],
    );
  }
}
