import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/location/location_provider.dart';
import '../../../../core/state/view_status.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_feedback.dart';
import '../../../../shared/widgets/app_page_header.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../data/models/prayer_times.dart';
import '../providers/prayer_provider.dart';
import '../widgets/city_search_dialog.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/prayer_tile.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  Future<void> _openCitySearch() async {
    final prayer = context.read<PrayerProvider>();
    final city = await CitySearchDialog.show(context, initialCity: prayer.city);
    if (city != null) await prayer.searchCity(city);
  }

  @override
  Widget build(BuildContext context) {
    final prayer = context.watch<PrayerProvider>();
    final location = context.watch<LocationProvider>();
    final placeLabel = prayer.city ?? location.current.label;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Shalat'),
        actions: [
          IconButton(
            onPressed: prayer.load,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: prayer.load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            AppPageHeader(
              icon: Icons.mosque_rounded,
              title: 'Jadwal Shalat',
              subtitle: '$placeLabel • ${location.current.coordinateLabel}',
            ),
            const SizedBox(height: 14),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.lime.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.place_rounded,
                            size: 20, color: AppColors.dark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              location.current.isDefault && prayer.city == null
                                  ? 'Lokasi default'
                                  : 'Lokasi jadwal',
                              style: AppTextStyle.caption,
                              color: AppColors.muted,
                            ),
                            AppText(placeLabel, style: AppTextStyle.subtitle),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          'Sinkron',
                          icon: Icons.sync_rounded,
                          loading: location.isLocating,
                          onPressed: location.useDeviceLocation,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          'Cari kota',
                          icon: Icons.search_rounded,
                          variant: AppButtonVariant.soft,
                          onPressed: _openCitySearch,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (location.message != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: AppText(
                  location.message!,
                  style: AppTextStyle.caption,
                  color: AppColors.muted,
                ),
              ),
            const SizedBox(height: 16),
            switch (prayer.status) {
              ViewStatus.loading => const AppLoading(
                  message: 'Mengambil jadwal shalat...',
                ),
              ViewStatus.error => AppErrorView(
                  message: prayer.error ?? 'Gagal memuat data.',
                  onRetry: prayer.load,
                ),
              _ => _buildSchedule(prayer.times),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildSchedule(PrayerTimes? times) {
    if (times == null) return const SizedBox.shrink();
    final nextKey = times.nextPrayer(DateTime.now()).key;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NextPrayerCard(times: times),
        const SizedBox(height: 18),
        const AppText('Jadwal hari ini', style: AppTextStyle.title),
        const SizedBox(height: 10),
        ...times.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PrayerTile(entry: entry, isNext: entry.key == nextKey),
          ),
        ),
        const SizedBox(height: 4),
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText('Imsak',
                        style: AppTextStyle.caption, color: AppColors.muted),
                    const SizedBox(height: 2),
                    AppText(times.imsak, style: AppTextStyle.subtitle),
                  ],
                ),
              ),
              Container(width: 1, height: 34, color: AppColors.border),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText('Terbit',
                        style: AppTextStyle.caption, color: AppColors.muted),
                    const SizedBox(height: 2),
                    AppText(times.sunrise, style: AppTextStyle.subtitle),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        AppText(
          'Metode Kementerian Agama RI • ${times.timezone}',
          style: AppTextStyle.caption,
          color: AppColors.muted,
          align: TextAlign.center,
        ),
      ],
    );
  }
}
