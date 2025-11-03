import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snuz_app/l10n/app_localizations.dart';
import 'package:snuz_app/providers/audio_player_provider.dart';
import 'package:snuz_app/providers/auth_provider.dart';
import 'package:snuz_app/providers/sleepcast_provider.dart';
import 'package:snuz_app/router.dart';
import 'package:wiredash/wiredash.dart';

late AppLocalizations l10n;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) => true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final prefs = await SharedPreferences.getInstance();
  final locale = prefs.getString('locale') ?? 'en';
  l10n = await AppLocalizations.delegate.load(Locale(locale));
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SleepcastProvider()..init()),
        ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _router = createRouter(authProvider);
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was opened from a link
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null && mounted) {
        _handleIncomingLink(initialLink);
      }
    } catch (e) {
      debugPrint('Failed to get initial link: $e');
    }

    // Listen for links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        if (mounted) {
          _handleIncomingLink(uri);
        }
      },
      onError: (err) {
        debugPrint('Failed to get link: $err');
      },
    );
  }

  Future<void> _handleIncomingLink(Uri uri) async {
    final authProvider = context.read<AuthProvider>();

    // Check if this is a Firebase auth link
    if (uri.toString().length < 30) {
      debugPrint('Short URI with no login data');
      return;
    }

    final success = await authProvider.signInWithEmailLink(uri.toString());

    if (mounted && !success && authProvider.errorMessage != null) {
      // The router will automatically redirect to home when auth state changes
      // Show error if sign-in failed
      ScaffoldMessenger.of(_router.routerDelegate.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

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
      child: MaterialApp.router(
        title: 'Snuz App',
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: theme,
        routerConfig: _router,
      ),
    );
  }
}

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1d223f)),
  useMaterial3: true,
  primaryColor: const Color(0xFF1d223f),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white.withValues(alpha: 0.9),
    iconTheme: IconThemeData(color: Colors.white.withValues(alpha: 0.9)),
  ),
  snackBarTheme: const SnackBarThemeData(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(const Color(0xFF1d223f).withValues(alpha: 0.8)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      side: WidgetStateProperty.all(BorderSide(color: Colors.white.withValues(alpha: 0.2))),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xFF1d223f),
    titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    contentTextStyle: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.9)),
  ),
  textTheme: TextTheme(
    headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.9)),
    headlineSmall: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9)),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9)),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.8)),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8)),
    bodySmall: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.7)),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.7)),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.5)),
  ),
);
