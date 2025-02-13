import 'package:flutter/foundation.dart';
import 'package:snuz_app/models/sleepcast.dart';

class SleepcastProvider with ChangeNotifier {
  final List<Sleepcast> _sleepcastStory = [];
  final List<Sleepcast> _sleepcastSOS = [];

  List<Sleepcast> get sleepcastStory => _sleepcastStory;
  List<Sleepcast> get sleepcastSOS => _sleepcastSOS;

  SleepcastProvider() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _sleepcastStory.addAll([
      Sleepcast(
        id: 'story_1',
        title: 'Forest Walk',
        description: 'A relaxing walk through a peaceful forest, accompanied by gentle rustling leaves.',
        title_de: 'Waldspaziergang',
        description_de:
            'Ein entspannender Spaziergang durch einen friedlichen Wald, begleitet vom sanften Rascheln der Blätter.',
        duration: const Duration(minutes: 20),
      ),
      Sleepcast(
        id: 'story_2',
        title: 'Ocean Waves',
        description: 'Listen to the soothing waves of the ocean on a secluded beach.',
        title_de: 'Meeresrauschen',
        description_de: 'Lausche den beruhigenden Wellen des Ozeans an einem einsamen Strand.',
        duration: const Duration(minutes: 15),
      ),
      Sleepcast(
        id: 'story_3',
        title: 'Raindrops',
        description: 'A cozy evening at home while gentle summer rain taps against the window.',
        title_de: 'Regentropfen',
        description_de:
            'Ein gemütlicher Abend zuhause, während draußen ein sanfter Sommerregen gegen das Fenster prasselt.',
        duration: const Duration(minutes: 25),
      ),
      Sleepcast(
        id: 'story_4',
        title: 'Mountain Hike',
        description: 'A peaceful hike through majestic mountains with breathtaking views.',
        title_de: 'Bergwanderung',
        description_de: 'Eine friedvolle Wanderung durch die majestätischen Berge mit atemberaubenden Ausblicken.',
        duration: const Duration(minutes: 18),
      ),
    ]);

    _sleepcastSOS.addAll([
      Sleepcast(
        id: 'sos_1',
        title: 'Headache Relief',
        description:
            'A guided relaxation with gentle breathing exercises and visualizations for quick headache relief.',
        title_de: 'Kopfschmerzen lindern',
        description_de:
            'Eine geführte Entspannung mit sanften Atemübungen und Visualisierungen zur schnellen Schmerzlinderung.',
        duration: const Duration(minutes: 8),
      ),
      Sleepcast(
        id: 'sos_2',
        title: 'Acute Stress',
        description:
            'Quick relief for acute stress through progressive muscle relaxation and calming breathing techniques.',
        title_de: 'Akuter Stress',
        description_de:
            'Schnelle Hilfe bei akutem Stress durch progressive Muskelentspannung und beruhigende Atemtechniken.',
        duration: const Duration(minutes: 10),
      ),
      Sleepcast(
        id: 'sos_3',
        title: 'Back Pain',
        description: 'Targeted relaxation exercises and body awareness for quick back pain relief while lying down.',
        title_de: 'Rückenschmerzen',
        description_de:
            'Gezielte Entspannungsübungen und Körperwahrnehmung zur schnellen Linderung von Rückenschmerzen im Liegen.',
        duration: const Duration(minutes: 12),
      ),
    ]);

    notifyListeners();
  }
}
