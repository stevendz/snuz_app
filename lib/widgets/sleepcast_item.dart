import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:snuz_app/l10n/sleepcast_descriptions.dart';
import 'package:snuz_app/main.dart';
import 'package:snuz_app/models/sleepcast.dart';
import 'package:snuz_app/providers/audio_player_provider.dart';
import 'package:snuz_app/providers/sleepcast_provider.dart';
import 'package:snuz_app/screens/sleepcast_player_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    final sleepcastProvider = context.watch<SleepcastProvider>();
    final audioPlayerProvider = context.watch<AudioPlayerProvider>();
    final textTheme = Theme.of(context).textTheme;
    final isDownloaded = sleepcastProvider.isDownloaded(widget.cast.id);
    final isLoading = sleepcastProvider.loadingSleepcasts[widget.cast] != null;
    return Opacity(
      opacity: isLoading ? 0.5 : 1,
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Material(
          key: GlobalKey(),
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading || sleepcastProvider.loadingSleepcasts.isNotEmpty
                ? null
                : () async {
                    await sleepcastProvider.downloadSleepcast(widget.cast);
                    if (!sleepcastProvider.isDownloaded(widget.cast.id)) return;
                    final path = sleepcastProvider.getSleepcastPath(widget.cast.id);
                    await audioPlayerProvider.openSleepcast(widget.cast, path);
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SleepcastPlayerScreen(cast: widget.cast)),
                    );
                  },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isLoading
                              ? '${l10n.isLoading} ${((sleepcastProvider.loadingSleepcasts.entries.firstOrNull?.value ?? 0) * 100).toStringAsFixed(0)}%'
                              : Sleepcasts().getTitle(widget.cast.id),
                          style: textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isDownloaded)
                        Icon(
                          HugeIcons.strokeRoundedDownload04,
                          color: textTheme.bodyMedium?.color?.withValues(alpha: 1),
                          size: 20,
                        )
                      else
                        Icon(
                          HugeIcons.strokeRoundedDownload04,
                          color: textTheme.bodyMedium?.color?.withValues(alpha: 0.15),
                          size: 20,
                        ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('${widget.cast.duration.inMinutes} min', style: textTheme.bodyMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Sleepcasts().getDescription(widget.cast.id),
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
