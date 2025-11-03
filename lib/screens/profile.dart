import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snuz_app/l10n/sleepcast_descriptions.dart';
import 'package:snuz_app/main.dart';
import 'package:snuz_app/providers/auth_provider.dart';
import 'package:snuz_app/providers/locale_provider.dart';
import 'package:snuz_app/providers/sleepcast_provider.dart';
import 'package:snuz_app/providers/snackbar_service.dart';
import 'package:snuz_app/screens/sleepcast_player_screen.dart';
import 'package:snuz_app/utils/snackbar_data.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  Text(l10n.downloadedMeditations, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  if (!castProvider.isAnySleepcastDownloaded)
                    Text(
                      l10n.noDownloadsYet,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  else
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
                              MaterialPageRoute(builder: (context) => SleepcastPlayerScreen(cast: cast)),
                            );
                          },
                          trailing: IconButton(
                            onPressed: () => castProvider.deleteDownloadedSleepcast(cast),
                            icon: const Icon(Icons.delete, color: Color(0xffb63b45), size: 20),
                          ),
                        ),
                  const SizedBox(height: 16),
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
                          if (locale != null && context.mounted) {
                            await context.read<LocaleProvider>().setLocale(locale);
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.featureRequest, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      final url = Uri.parse('https://snuz.featurebase.app/');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Text(
                      l10n.submitFeatureRequest,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.logout, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(l10n.logout),
                          content: Text(l10n.logoutConfirmation),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(l10n.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(l10n.logout),
                            ),
                          ],
                        ),
                      );

                      if (shouldLogout == true && context.mounted) {
                        await context.read<AuthProvider>().signOut();
                        // Router will automatically redirect to /auth
                      }
                    },
                    child: Text(
                      l10n.logout,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                    ),
                  ),
                  Visibility(
                    // ignore: avoid_redundant_argument_values
                    visible: kDebugMode,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        Text('Developer Section', style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            SnackbarService.instance.showSnackbar(SnackbarData().downloadedSuccessfully);
                          },
                          child: const Text('Success'),
                        ),
                        TextButton(
                          onPressed: () {
                            SnackbarService.instance.showSnackbar(SnackbarData().noInternet);
                          },
                          child: const Text('Info'),
                        ),
                        TextButton(
                          onPressed: () {
                            SnackbarService.instance.showSnackbar(SnackbarData().error);
                          },
                          child: const Text('Error'),
                        ),
                      ],
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
