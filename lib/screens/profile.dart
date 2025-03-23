import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:snuz_app/l10n/sleepcast_descriptions.dart';
import 'package:snuz_app/main.dart';
import 'package:snuz_app/providers/sleepcast_provider.dart';
import 'package:snuz_app/screens/overview.dart';
import 'package:snuz_app/screens/sleepcast_player_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final castProvider = context.watch<SleepcastProvider>();
    final locale = Locale(l10n.localeName);

    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(l10n.profile, style: Theme.of(context).textTheme.headlineMedium),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.language, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return DropdownMenu<Locale>(
                        width: constraints.maxWidth,
                        initialSelection: locale,
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: const Locale('en', ''), label: l10n.english),
                          DropdownMenuEntry(value: const Locale('de', ''), label: l10n.german),
                        ],
                        onSelected: (locale) async {
                          l10n = await AppLocalizations.delegate.load(locale!);
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const OverviewScreen()),
                            (route) => false,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.downloadedMeditations, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  for (final cast in [...castProvider.sleepcastSOS, ...castProvider.sleepcastStory])
                    if (castProvider.isDownloaded(cast.id))
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.download_done_rounded,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          size: 20,
                        ),
                        title: Text(
                          Sleepcasts().getTitle(cast.id),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SleepcastPlayerScreen(sleepcast: cast)),
                          );
                        },
                        trailing: IconButton(
                          onPressed: () => castProvider.deleteDownloadedSleepcast(cast),
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        ),
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
