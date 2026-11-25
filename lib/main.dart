import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/location/location_provider.dart';
import 'core/location/location_service.dart';
import 'core/theme/app_theme.dart';
import 'features/prayer/data/services/prayer_api_service.dart';
import 'features/prayer/presentation/providers/prayer_provider.dart';
import 'features/qibla/presentation/providers/qibla_provider.dart';
import 'features/quran/data/local/bookmark_storage.dart';
import 'features/quran/data/services/quran_api_service.dart';
import 'features/quran/presentation/providers/quran_provider.dart';
import 'features/shell/presentation/screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final locationProvider = LocationProvider(LocationService());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locationProvider),
        ChangeNotifierProvider(
          create: (_) => PrayerProvider(PrayerApiService(), locationProvider),
        ),
        ChangeNotifierProvider(
          create: (_) => QiblaProvider(locationProvider),
        ),
        ChangeNotifierProvider(
          create: (_) => QuranProvider(QuranApiService(), BookmarkStorage()),
        ),
      ],
      child: const MoeslemApp(),
    ),
  );
}

class MoeslemApp extends StatelessWidget {
  const MoeslemApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Moeslem',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const MainShell(),
      );
}
