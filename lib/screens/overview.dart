import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:snuz_app/providers/locale_provider.dart';
import 'package:snuz_app/providers/sleepcast_provider.dart';
import 'package:snuz_app/widgets/sleepcast_item.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sleepcastProvider = context.watch<SleepcastProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return Localizations(
      locale: localeProvider.locale,
      delegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: Builder(builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Lottie.asset('assets/animations/background.json', fit: BoxFit.cover, repeat: true),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  PopupMenuButton<Locale>(
                    onSelected: (locale) => context.read<LocaleProvider>().setLocale(locale),
                    itemBuilder: (BuildContext context) => const [
                      PopupMenuItem(
                        value: Locale('en', ''),
                        child: Text('English'),
                      ),
                      PopupMenuItem(
                        value: Locale('de', ''),
                        child: Text('Deutsch'),
                      ),
                    ],
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sleepcasts', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 16),
                      for (final cast in sleepcastProvider.sleepcastStory) ...[
                        SleepcastItem(cast: cast),
                        const SizedBox(height: 16),
                      ],
                      Text('SOS', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 16),
                      for (final cast in sleepcastProvider.sleepcastSOS) ...[
                        SleepcastItem(cast: cast),
                        const SizedBox(height: 16),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
