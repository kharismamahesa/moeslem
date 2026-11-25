import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../data/models/prayer_times.dart';

class NextPrayerCard extends StatefulWidget {
  const NextPrayerCard({super.key, required this.times});

  final PrayerTimes times;

  @override
  State<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<NextPrayerCard> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final next = widget.times.nextPrayer(_now);
    final countdown = formatCountdown(widget.times.timeUntil(next, _now));

    return AppCard(
      color: AppColors.dark,
      borderColor: AppColors.dark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  size: 16, color: AppColors.lime),
              const SizedBox(width: 6),
              AppText(
                'SHALAT BERIKUTNYA',
                style: AppTextStyle.caption,
                color: AppColors.lime,
                weight: FontWeight.w700,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                next.time,
                style: AppTextStyle.display,
                color: AppColors.white,
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: AppText(
                  next.label,
                  style: AppTextStyle.subtitle,
                  color: AppColors.lime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppChip(
            label: 'Masih $countdown',
            icon: Icons.schedule_rounded,
            background: AppColors.lime.withValues(alpha: 0.2),
            foreground: AppColors.lime,
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.white.withValues(alpha: 0.25)),
          const SizedBox(height: 10),
          AppText(
            '${widget.times.dateLabel}  •  ${widget.times.hijriLabel}',
            style: AppTextStyle.caption,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }
}
