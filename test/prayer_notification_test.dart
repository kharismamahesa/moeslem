import 'package:flutter_test/flutter_test.dart';
import 'package:moeslem/core/notifications/prayer_notification_time.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(() => tz_data.initializeTimeZones());

  test('schedules prayer time on the same day in its own timezone', () {
    final location = tz.getLocation('Asia/Jakarta');
    final now = tz.TZDateTime(location, 2026, 11, 26, 3, 0);

    final scheduled = prayerNotificationDateTime('04:30', 'Asia/Jakarta', now);

    expect(scheduled, tz.TZDateTime(location, 2026, 11, 26, 4, 30));
  });

  test('rolls a past prayer time to the next day', () {
    final location = tz.getLocation('Asia/Jakarta');
    final now = tz.TZDateTime(location, 2026, 11, 26, 18, 0);

    final scheduled = prayerNotificationDateTime('17:35', 'Asia/Jakarta', now);

    expect(scheduled, tz.TZDateTime(location, 2026, 11, 27, 17, 35));
  });

  test('falls back to local timezone when the timezone is unknown', () {
    final now = tz.TZDateTime(tz.local, 2026, 11, 26, 3, 0);

    final scheduled = prayerNotificationDateTime('04:30', '', now);

    expect(scheduled.location, tz.local);
    expect(scheduled.hour, 4);
    expect(scheduled.minute, 30);
  });
}
