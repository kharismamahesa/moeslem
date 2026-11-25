import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/location/location_provider.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_page_header.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../data/services/qibla_calculator.dart';
import '../providers/qibla_provider.dart';
import '../widgets/qibla_compass.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final qibla = context.watch<QiblaProvider>();
    final location = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Arah Kiblat')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          AppPageHeader(
            icon: Icons.explore_rounded,
            title: 'Arah Kiblat',
            subtitle: '${location.current.label} • ${location.current.coordinateLabel}',
            trailing: IconButton(
              onPressed: location.useDeviceLocation,
              icon: const Icon(Icons.my_location_rounded, color: AppColors.lime),
              tooltip: 'Gunakan lokasi saya',
            ),
          ),
            const SizedBox(height: 16),
            if (location.message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppText(
                  location.message!,
                  style: AppTextStyle.caption,
                  color: AppColors.muted,
                ),
              ),
            AppCard(
              child: Column(
              children: [
                QiblaCompass(bearing: qibla.bearing),
                const SizedBox(height: 14),
                AppChip(
                  label: 'Menghadap ${qibla.directionLabel}',
                  icon: Icons.navigation_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText('Sudut arah kiblat',
                          style: AppTextStyle.caption, color: AppColors.muted),
                      const SizedBox(height: 4),
                      AppText(
                        '${qibla.bearing.toStringAsFixed(1)}°',
                        style: AppTextStyle.display,
                        color: AppColors.dark,
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 46, color: AppColors.border),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText('Dari utara sejati',
                          style: AppTextStyle.caption, color: AppColors.muted),
                      const SizedBox(height: 6),
                      AppText(qibla.directionLabel, style: AppTextStyle.subtitle),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            color: AppColors.surface,
            borderColor: AppColors.lime,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 20, color: AppColors.dark),
                const SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    location.current.isDefault
                        ? 'Menggunakan lokasi default Pekanbaru, Riau. Aktifkan izin lokasi untuk arah yang sesuai posisi Anda.'
                        : 'Arah dihitung dari lokasi Anda menuju Ka\'bah (${QiblaCalculator.kaabaLatitude}°, ${QiblaCalculator.kaabaLongitude}°).',
                    style: AppTextStyle.caption,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  'Lokasi saya',
                  icon: Icons.my_location_rounded,
                  loading: location.isLocating,
                  onPressed: location.useDeviceLocation,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  'Pekanbaru',
                  icon: Icons.place_rounded,
                  variant: AppButtonVariant.soft,
                  onPressed: location.useDefault,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
