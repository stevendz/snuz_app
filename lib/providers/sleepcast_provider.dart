import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snuz_app/l10n/sleepcast_descriptions.dart';
import 'package:snuz_app/main.dart';
import 'package:snuz_app/models/sleepcast.dart';
import 'package:snuz_app/providers/snackbar_service.dart';
import 'package:snuz_app/utils/snackbar_data.dart';
import 'package:wiredash/wiredash.dart';

class SleepcastProvider with ChangeNotifier {
  late String _downloadDirectoryPath;
  final List<Sleepcast> _sleepcastStory = [];
  final List<Sleepcast> _sleepcastSOS = [];

  List<Sleepcast> get sleepcastStory => _sleepcastStory;
  List<Sleepcast> get sleepcastSOS => _sleepcastSOS;

  Map<Sleepcast, double> loadingSleepcasts = {};

  Future<void> init() async {
    await _setDownloadDirectory();
    _initializeDummyData();
  }

  Future<void> _setDownloadDirectory() async {
    if (Platform.isIOS) {
      _downloadDirectoryPath = '${(await getApplicationSupportDirectory()).path}/';
    } else if (Platform.isAndroid) {
      _downloadDirectoryPath = '${(await getApplicationDocumentsDirectory()).path}/';
    }
  }

  String getSleepcastPath(String id) {
    return '$_downloadDirectoryPath/sleepcasts/$id/${l10n.localeName}.mp3';
  }

  bool isDownloaded(String id) {
    return File('$_downloadDirectoryPath/sleepcasts/$id/${l10n.localeName}.mp3').existsSync();
  }

  Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<bool> _isNewVersionAvailable(String id) async {
    final path = '/sleepcasts/$id/${l10n.localeName}.mp3';
    final resp = await Dio().head(
      'https://snuz-app.webrabbits.workers.dev$path',
      options: Options(headers: {'auth': 'BLiM8TRxhKC0UGAgr5LY6dnzCyH1zBOf'}),
    );
    final file = File('$_downloadDirectoryPath$path');
    final format = DateFormat('EEE MMM dd yyyy HH:mm:ss', 'en_US');
    final DateTime lastModifiedServerUtc = format.parse(resp.headers.map['uploaded']?.first ?? '');
    final DateTime l = file.statSync().modified.toUtc();
    final DateTime lastModifiedLocalUtc = DateTime(l.year, l.month, l.day, l.hour, l.minute, l.second);
    return lastModifiedServerUtc.isAfter(lastModifiedLocalUtc);
  }

  Future<void> downloadSleepcast(Sleepcast cast) async {
    try {
      if (!await isOnline()) {
        SnackbarService.instance.showSnackbar(SnackbarData().noInternet);
        return;
      }

      final isUpdateAvailable = await _isNewVersionAvailable(cast.id);
      if (isDownloaded(cast.id) && !isUpdateAvailable) return;

      Wiredash.trackEvent(
        isUpdateAvailable ? 'update_sleepcast' : 'download_sleepcast',
        data: {'id': cast.id, 'title': Sleepcasts().getTitle(cast.id), 'locale': l10n.localeName},
      );

      loadingSleepcasts[cast] = 0;
      notifyListeners();
      final path = '/sleepcasts/${cast.id}/${l10n.localeName}.mp3';
      final resp = await Dio().download(
        'https://snuz-app.webrabbits.workers.dev$path',
        options: Options(headers: {'auth': 'BLiM8TRxhKC0UGAgr5LY6dnzCyH1zBOf'}),
        '$_downloadDirectoryPath$path',
        onReceiveProgress: (received, total) {
          loadingSleepcasts[cast] = received / total;
          notifyListeners();
        },
      );
      if (resp.statusCode == 200) {
        loadingSleepcasts.remove(cast);
        SnackbarService.instance.showSnackbar(SnackbarData().downloadedSuccessfully);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
      SnackbarService.instance.showSnackbar(SnackbarData().error);
      Wiredash.trackEvent('Error loading sleepcast', data: {'id': cast.id, 'error': e.toString()});
      loadingSleepcasts.remove(cast);
      notifyListeners();
    }
  }

  void deleteDownloadedSleepcast(Sleepcast cast) {
    final file = File('$_downloadDirectoryPath/sleepcasts/${cast.id}/${l10n.localeName}.mp3');
    if (file.existsSync()) {
      file.deleteSync();
    }
    notifyListeners();
  }

  Future<void> _initializeDummyData() async {
    _sleepcastStory.addAll([
      Sleepcast(id: 'cast_1', duration: const Duration(minutes: 25), locale: ['de']),
      Sleepcast(id: 'cast_2', duration: const Duration(minutes: 30), locale: ['de']),
    ]);

    _sleepcastSOS.addAll([
      Sleepcast(id: 'sos_1', duration: const Duration(minutes: 10), locale: ['de']),
      Sleepcast(id: 'sos_2', duration: const Duration(minutes: 10), locale: ['de']),
      Sleepcast(id: 'sos_3', duration: const Duration(minutes: 10), locale: ['de']),
    ]);

    notifyListeners();
  }
}
