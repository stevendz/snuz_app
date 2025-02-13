import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snuz_app/providers/locale_provider.dart';
import 'package:snuz_app/providers/sleepcast_provider.dart';
import 'package:snuz_app/screens/overview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()..initLocale()),
        ChangeNotifierProvider(create: (_) => SleepcastProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snuz App',
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: theme,
      home: const OverviewScreen(),
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
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.7)),
  ),
);
