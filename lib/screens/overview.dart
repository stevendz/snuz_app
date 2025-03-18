import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
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
      child: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Stack(
            children: [
              Positioned.fill(
                child: Lottie.asset('assets/animations/background.json', fit: BoxFit.cover, repeat: true),
              ),
              SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l10n.goodEvening, style: Theme.of(context).textTheme.headlineLarge),
                              PopupMenuButton<Locale>(
                                color: Theme.of(context).textTheme.headlineLarge?.color,
                                icon: Icon(
                                  Icons.person_outline_rounded,
                                  color: Theme.of(context).textTheme.headlineMedium?.color,
                                ),
                                position: PopupMenuPosition.under,
                                onSelected: (locale) => context.read<LocaleProvider>().setLocale(locale),
                                itemBuilder: (BuildContext context) => const [
                                  PopupMenuItem(value: Locale('en', ''), child: Text('English')),
                                  PopupMenuItem(value: Locale('de', ''), child: Text('Deutsch')),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            l10n.dreamJourneyQuestion,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 32),
                          Text(l10n.sleepcasts, style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 16),
                          for (final cast in sleepcastProvider.sleepcastStory) ...[
                            SleepcastItem(cast: cast),
                            const SizedBox(height: 16),
                          ],
                          const SizedBox(height: 32),
                          Text(l10n.sos, style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 16),
                          for (final cast in sleepcastProvider.sleepcastSOS) ...[
                            SleepcastItem(cast: cast),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
