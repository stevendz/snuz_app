import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:snuz_app/l10n/sleepcast_descriptions.dart';
import 'package:snuz_app/main.dart';
import 'package:snuz_app/models/sleepcast.dart';
import 'package:snuz_app/providers/audio_player_provider.dart';
import 'package:wiredash/wiredash.dart';

class SleepcastPlayerScreen extends StatefulWidget {
  const SleepcastPlayerScreen({
    super.key,
    required this.cast,
  });

  final Sleepcast cast;

  @override
  State<SleepcastPlayerScreen> createState() => _SleepcastPlayerScreenState();
}

class _SleepcastPlayerScreenState extends State<SleepcastPlayerScreen> {
  @override
  void initState() {
    super.initState();
    Wiredash.trackEvent(
      'open_sleepcast',
      data: {
        'id': widget.cast.id,
        'title': Sleepcasts().getTitle(widget.cast.id),
        'locale': l10n.localeName,
      },
    );
  }

  @override
  void deactivate() {
    final player = context.read<AudioPlayerProvider>();
    Wiredash.trackEvent(
      'closing_sleepcast',
      data: {
        'id': widget.cast.id,
        'title': Sleepcasts().getTitle(widget.cast.id),
        'seconds': player.position.inSeconds,
      },
    );
    player.stop();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final audioPlayer = context.watch<AudioPlayerProvider>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Lottie.asset(
            'assets/animations/background_player.json',
            fit: BoxFit.fill,
            repeat: true,
            animate: audioPlayer.isPlaying,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
            child: Column(
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Sleepcasts().getTitle(widget.cast.id),
                        style: textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        Sleepcasts().getDescription(widget.cast.id),
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(32),
                  onPressed: audioPlayer.isPlaying ? audioPlayer.pause : audioPlayer.play,
                  icon: Icon(
                    audioPlayer.isPlaying ? HugeIcons.strokeRoundedPause : HugeIcons.strokeRoundedPlay,
                    color: textTheme.headlineLarge?.color?.withOpacity(0.8),
                    size: 48,
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PlayerProgressBar(
                        progress: audioPlayer.progress,
                        duration: widget.cast.duration,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar({
    super.key,
    required this.progress,
    required this.duration,
  });

  final double progress;
  final Duration duration;

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.round());
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds - minutes * 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.2),
          ),
          child: Slider(value: progress, onChanged: (_) {}),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(progress * duration.inSeconds), style: Theme.of(context).textTheme.bodySmall),
              Text(_formatDuration(duration.inSeconds.toDouble()), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
