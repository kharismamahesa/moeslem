import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;

import '../../features/prayer/data/models/prayer_times.dart';
import 'prayer_notification_time.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'moeslem_prayer';
  static const _channelName = 'Waktu Shalat';
  static const _channelDescription = 'Notifikasi ketika waktu shalat tiba';

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    await _plugin.initialize(
      settings: InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.defaultImportance,
            playSound: true,
          ),
        );
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android != null) {
        final granted = await android.requestNotificationsPermission() ?? false;
        if (!granted) return false;
        await android.requestExactAlarmsPermission();
        return true;
      }

      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (ios != null) {
        return await ios.requestPermissions(alert: true, sound: true) ?? false;
      }
      return true;
    } catch (error) {
      debugPrint('Gagal meminta izin notifikasi: $error');
      return false;
    }
  }

  Future<bool> schedulePrayerNotifications(PrayerTimes times) async {
    try {
      await initialize();
      await _plugin.cancelAllPendingNotifications();

      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final exactAllowed =
          await android?.canScheduleExactNotifications() ?? true;
      final scheduleMode = exactAllowed
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;

      for (var index = 0; index < times.entries.length; index++) {
        final entry = times.entries[index];
        await _plugin.zonedSchedule(
          id: index + 1,
          title: 'Waktu ${entry.label}',
          body: 'Telah masuk waktu shalat ${entry.label}.',
          scheduledDate: prayerNotificationDateTime(entry.time, times.timezone),
          payload: entry.key,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              _channelName,
              channelDescription: _channelDescription,
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
              playSound: true,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: scheduleMode,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
      return true;
    } catch (error) {
      debugPrint('Gagal menjadwalkan notifikasi shalat: $error');
      return false;
    }
  }
}
