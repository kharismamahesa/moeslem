import 'package:flutter/material.dart';

class PrayerEntry {
  const PrayerEntry({
    required this.key,
    required this.label,
    required this.time,
    required this.icon,
  });

  final String key;
  final String label;
  final String time;
  final IconData icon;

  DateTime dateTime(DateTime now) {
    final parts = time.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.tryParse(parts.first) ?? 0,
      int.tryParse(parts.last) ?? 0,
    );
  }
}

class PrayerTimes {
  PrayerTimes.fromJson(Map<String, dynamic> body) {
    final data = body['data'] as Map<String, dynamic>;
    final timings = data['timings'] as Map<String, dynamic>;
    final date = data['date'] as Map<String, dynamic>;
    final hijri = date['hijri'] as Map<String, dynamic>;
    final month = hijri['month'] as Map<String, dynamic>;
    final meta = data['meta'] as Map<String, dynamic>;

    String time(String key) => timings[key]?.toString() ?? '--:--';

    _imsak = time('Imsak');
    _sunrise = time('Sunrise');
    _dateLabel = date['readable']?.toString() ?? '';
    _hijriLabel = '${hijri['date']} ${month['en']} ${hijri['year']} H';
    _timezone = meta['timezone']?.toString() ?? '';
    _entries = [
      PrayerEntry(key: 'Fajr', label: 'Subuh', time: time('Fajr'), icon: Icons.wb_twilight_rounded),
      PrayerEntry(key: 'Dhuhr', label: 'Dzuhur', time: time('Dhuhr'), icon: Icons.wb_sunny_rounded),
      PrayerEntry(key: 'Asr', label: 'Ashar', time: time('Asr'), icon: Icons.light_mode_rounded),
      PrayerEntry(key: 'Maghrib', label: 'Maghrib', time: time('Maghrib'), icon: Icons.wb_twilight_outlined),
      PrayerEntry(key: 'Isha', label: 'Isya', time: time('Isha'), icon: Icons.nightlight_rounded),
    ];
  }

  late final String _imsak;
  late final String _sunrise;
  late final String _dateLabel;
  late final String _hijriLabel;
  late final String _timezone;
  late final List<PrayerEntry> _entries;

  String get imsak => _imsak;
  String get sunrise => _sunrise;
  String get dateLabel => _dateLabel;
  String get hijriLabel => _hijriLabel;
  String get timezone => _timezone;
  List<PrayerEntry> get entries => _entries;

  PrayerEntry nextPrayer(DateTime now) {
    for (final entry in _entries) {
      if (entry.dateTime(now).isAfter(now)) return entry;
    }
    return _entries.first;
  }

  Duration timeUntil(PrayerEntry entry, DateTime now) {
    final target = entry.dateTime(now);
    return (target.isAfter(now) ? target : target.add(const Duration(days: 1)))
        .difference(now);
  }
}
