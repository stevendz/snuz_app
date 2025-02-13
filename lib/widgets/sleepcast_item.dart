import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snuz_app/models/sleepcast.dart';
import 'package:snuz_app/providers/locale_provider.dart';
import 'package:snuz_app/screens/sleepcast_player_screen.dart';

class SleepcastItem extends StatelessWidget {
  const SleepcastItem({
    super.key,
    required this.cast,
  });

  final Sleepcast cast;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final locale = context.watch<LocaleProvider>().locale.languageCode;
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xCC1d223f),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SleepcastPlayerScreen(sleepcast: cast)),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale == 'de' ? cast.titleDe : cast.title,
                      style: textTheme.titleLarge,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${cast.duration.inMinutes} min', style: textTheme.bodyMedium),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  locale == 'de' ? cast.descriptionDe : cast.description,
                  style: textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
