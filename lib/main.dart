import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snuz_app/providers/audio_player_provider.dart';
import 'package:snuz_app/providers/locale_provider.dart';
import 'package:snuz_app/providers/sleepcast_provider.dart';
import 'package:snuz_app/screens/overview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wiredash/wiredash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) => true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()..initLocale()),
        ChangeNotifierProvider(create: (_) => SleepcastProvider()..init()),
        ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      projectId: 'snuz-rq0jtyj',
      secret: 'w1cLKfgf1nA2Ron-RgAt3ZHUnINfrKMU',
      options: const WiredashOptionsData(locale: Locale('de')),
      theme: WiredashThemeData(
        primaryColor: const Color(0xFF1D223F),
        secondaryColor: const Color(0xFF2C354F),
        primaryBackgroundColor: const Color(0xFF1D223F),
        secondaryBackgroundColor: const Color(0xFF2C354F),
        textOnPrimaryContainerColor: Colors.white70,
        textOnSecondaryContainerColor: Colors.white70,
        primaryTextOnBackgroundColor: Colors.white70,
        secondaryTextOnBackgroundColor: Colors.white70,
        errorColor: const Color(0xFFE53935),
      ),
      child: MaterialApp(
        title: 'Snuz App',
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: theme,
        home: const OverviewScreen(),
      ),
    );
  }
}

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  textTheme: TextTheme(
    headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.8)),
    headlineSmall: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9)),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9)),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
    bodySmall: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.7)),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.7)),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.5)),
  ),
);
