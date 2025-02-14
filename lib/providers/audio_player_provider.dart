import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:snuz_app/l10n/sleepcast_descriptions.dart';
import 'package:snuz_app/models/sleepcast.dart';
import 'package:wiredash/wiredash.dart';

class AudioPlayerProvider with ChangeNotifier {
  final AssetsAudioPlayer _player = AssetsAudioPlayer.newPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  AudioPlayerProvider() {
    _init();
  }

  void _init() {
    _player.isPlaying.listen((playing) {
      _isPlaying = playing;
      notifyListeners();
    });

    _player.currentPosition.listen((position) {
      _position = position;
      notifyListeners();
    });

    _player.current.listen((playingAudio) {
      _duration = playingAudio?.audio.duration ?? Duration.zero;
      notifyListeners();
    });

    // _player.playlistAudioFinished.listen((Playing playing) {
    //   _player.seek(Duration.zero);
    //   _player.pause();
    // });
  }

  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  double get progress => duration.inSeconds > 0 ? position.inSeconds / duration.inSeconds : 0.0;

  Future<void> openSleepcast(Sleepcast cast, String path, String locale) async {
    try {
      await _player.open(
        Audio.file(
          path,
          metas: Metas(
            id: cast.id,
            title: Sleepcasts.getTitle(cast.id, locale),
            artist: "Snuz",
            album: "Snuz Sleepcasts",
            extra: {
              'title': Sleepcasts.getTitle(cast.id, locale),
              'description': Sleepcasts.getDescription(cast.id, locale),
            },
          ),
        ),
        autoStart: false,
        showNotification: true,
        notificationSettings: const NotificationSettings(prevEnabled: false, nextEnabled: false),
        audioFocusStrategy: const AudioFocusStrategy.request(
          resumeAfterInterruption: true,
          resumeOthersPlayersAfterDone: true,
        ),
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        playInBackground: PlayInBackground.enabled,
      );

      notifyListeners();
    } catch (e) {
      Wiredash.trackEvent(
        'error_opening_sleepcast',
        data: {'id': cast.id, 'title': Sleepcasts.getTitle(cast.id, locale)},
      );
    }
  }

  Future<void> pause() async {
    await _player.pause();
    notifyListeners();
  }

  Future<void> resume() async {
    await _player.play();
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
