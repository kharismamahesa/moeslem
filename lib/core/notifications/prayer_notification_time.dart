import 'package:timezone/timezone.dart' as tz;

tz.TZDateTime prayerNotificationDateTime(
  String time,
  String timeZone, [
  tz.TZDateTime? now,
]) {
  final parts = time.split(':');
  final hour = int.tryParse(parts.first) ?? 0;
  final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
  final location = notificationLocation(timeZone);
  final current = now ?? tz.TZDateTime.now(location);

  var scheduled = tz.TZDateTime(
    location,
    current.year,
    current.month,
    current.day,
    hour,
    minute,
  );
  if (!scheduled.isAfter(current)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

tz.Location notificationLocation(String timeZone) {
  if (timeZone.isEmpty) return tz.local;
  try {
    return tz.getLocation(timeZone);
  } catch (_) {
    return tz.local;
  }
}
