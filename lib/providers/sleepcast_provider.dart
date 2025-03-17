import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snuz_app/models/sleepcast.dart';
import 'package:snuz_app/utils/r2_service.dart';

class SleepcastProvider with ChangeNotifier {
  late String _downloadDirectoryPath;
  final List<Sleepcast> _sleepcastStory = [];
  final List<Sleepcast> _sleepcastSOS = [];

  List<Sleepcast> get sleepcastStory => _sleepcastStory;
  List<Sleepcast> get sleepcastSOS => _sleepcastSOS;

  Map<String, double> loadingSleepcasts = {};

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

  String getSleepcastPath(String id, String locale) {
    return '$_downloadDirectoryPath/sleepcasts/$id/$locale.mp3';
  }

  bool isDownloaded(String id, String locale) {
    return File('$_downloadDirectoryPath/sleepcasts/$id/$locale.mp3').existsSync();
  }

  Future<Sleepcast?> downloadSleepcast(Sleepcast cast, String locale) async {
    if (isDownloaded(cast.id, locale)) return cast;

    loadingSleepcasts[cast.id] = 0;
    notifyListeners();
    try {
      final R2Service service = R2Service();
      final url =
          await service.getPresignedUrl(key: 'sleepcasts/${cast.id}/$locale.mp3', expiration: const Duration(hours: 1));
      final savePath = '$_downloadDirectoryPath/sleepcasts/${cast.id}/$locale.mp3';
      final resp = await Dio().download(url, savePath, onReceiveProgress: (received, total) {
        loadingSleepcasts[cast.id] = received / total;
        notifyListeners();
      });
      if (resp.statusCode == 200) {
        loadingSleepcasts.remove(cast.id);
        notifyListeners();
      }
      return cast;
    } catch (e) {
      log(e.toString());
      // Wiredash.trackEvent(
      //   'Error loading sleepcast',
      //   data: {'id': cast.id, 'error': e.toString()},
      // );
      loadingSleepcasts.remove(cast.id);
      notifyListeners();
      return null;
    }
  }

  void _initializeDummyData() async {
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
