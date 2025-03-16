class Sleepcasts {
  static String getTitle(String id, String locale) {
    final title = {
      'en': {
        'sos_1': 'Racing Thoughts',
        'sos_2': 'Fear of Tomorrow',
        'sos_3': 'A Stressful Day',
      },
      'de': {
        'sos_1': 'Gedankenkarussell',
        'sos_2': 'Angst vor morgen',
        'sos_3': 'Ein stressiger Tag',
      },
    };
    return title[locale]?[id] ?? title['en']?[id] ?? '';
  }

  static String getDescription(String id, String locale) {
    final descriptions = {
      'en': {
        'sos_1': 'A calming meditation with visualizations to organize racing thoughts.',
        'sos_2': 'Gentle breathing techniques and affirmations to ease fears about the future.',
        'sos_3': 'Relaxing exercises to find inner peace after a stressful day.',
      },
      'de': {
        'sos_1': 'Eine beruhigende Meditation mit Visualisierungen, um rasende Gedanken zu ordnen.',
        'sos_2': 'Sanfte Atemtechniken und Affirmationen, um Ängste vor der Zukunft zu lindern.',
        'sos_3': 'Entspannende Übungen, um nach einem stressigen Tag innere Ruhe zu finden.',
      }
    };

    return descriptions[locale]?[id] ?? descriptions['en']?[id] ?? 'Description not found';
  }
}
