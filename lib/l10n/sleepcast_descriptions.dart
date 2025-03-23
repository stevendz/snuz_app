import 'package:snuz_app/main.dart';

class Sleepcasts {
  String getTitle(String id) {
    final locale = l10n.localeName;
    final title = {
      'en': {
        'cast_1': 'Moroccan Garden',
        'cast_2': 'Whispering Books',
        'sos_1': 'Racing Thoughts',
        'sos_2': 'Fear of Tomorrow',
        'sos_3': 'A Stressful Day',
      },
      'de': {
        'cast_1': 'Marrokanischer Garten',
        'cast_2': 'Whispering Books',
        'sos_1': 'Gedankenkarussell',
        'sos_2': 'Angst vor morgen',
        'sos_3': 'Ein stressiger Tag',
      },
    };
    return title[locale]?[id] ?? title['en']?[id] ?? '';
  }

  String getDescription(String id) {
    final locale = l10n.localeName;
    final descriptions = {
      'en': {
        'cast_1': 'Relax and unwind in a tranquil Moroccan garden under the serene moonlight.',
        'cast_2': 'Unwind in the magical Whispering Books, where stories come alive and dreams begin.',
        'sos_1': 'A calming meditation with visualizations to organize racing thoughts.',
        'sos_2': 'Gentle breathing techniques and affirmations to ease fears about the future.',
        'sos_3': 'Relaxing exercises to find inner peace after a stressful day.',
      },
      'de': {
        'cast_1': 'Entspanne dich in einem ruhigen marokkanischen Garten unter dem sanften Mondlicht.',
        'cast_2': 'Entspanne dich im magischen Whispering Books, wo Geschichten lebendig werden und Träume beginnen.',
        'sos_1': 'Eine beruhigende Meditation mit Visualisierungen, um rasende Gedanken zu ordnen.',
        'sos_2': 'Sanfte Atemtechniken und Affirmationen, um Ängste vor der Zukunft zu lindern.',
        'sos_3': 'Entspannende Übungen, um nach einem stressigen Tag innere Ruhe zu finden.',
      },
    };

    return descriptions[locale]?[id] ?? descriptions['en']?[id] ?? 'Description not found';
  }
}
