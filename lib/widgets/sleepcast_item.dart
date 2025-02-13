import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snuz_app/models/sleepcast.dart';
import 'package:snuz_app/providers/audio_player_provider.dart';
import 'package:snuz_app/providers/locale_provider.dart';
import 'package:snuz_app/screens/sleepcast_player_screen.dart';
import 'package:wiredash/wiredash.dart';

class SleepcastItem extends StatefulWidget {
  const SleepcastItem({
    super.key,
    required this.cast,
  });

  final Sleepcast cast;

  @override
  State<SleepcastItem> createState() => _SleepcastItemState();
}

class _SleepcastItemState extends State<SleepcastItem> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final locale = context.watch<LocaleProvider>().locale.languageCode;
    return Opacity(
      opacity: isLoading ? 0.5 : 1,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xCC1d223f),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              await context.read<AudioPlayerProvider>().openSleepcast(widget.cast);
              Wiredash.trackEvent(
                'open_sleepcast',
                data: {'id': widget.cast.id, 'title': widget.cast.title, 'locale': locale},
              );
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SleepcastPlayerScreen(sleepcast: widget.cast)),
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
                        locale == 'de' ? widget.cast.titleDe : widget.cast.title,
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
                        child: Text('${widget.cast.duration.inMinutes} min', style: textTheme.bodyMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    locale == 'de' ? widget.cast.descriptionDe : widget.cast.description,
                    style: textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
