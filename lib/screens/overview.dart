import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:snuz_app/main.dart';
import 'package:snuz_app/providers/sleepcast_provider.dart';
import 'package:snuz_app/screens/profile.dart';
import 'package:snuz_app/utils/snackbar_listener.dart';
import 'package:snuz_app/widgets/sleepcast_item.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sleepcastProvider = context.watch<SleepcastProvider>();
    return Scaffold(
      body: SnackbarListener(
        child: Stack(
          children: [
            Positioned.fill(
              child: Lottie.asset('assets/animations/background.json', fit: BoxFit.cover, repeat: true),
            ),
            SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.goodEvening, style: Theme.of(context).textTheme.headlineLarge),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (c) => const ProfileScreen()));
                              },
                              icon: Icon(
                                Icons.person_outline_rounded,
                                color: Theme.of(context).textTheme.headlineMedium?.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
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
        ),
      ),
    );
  }
}
