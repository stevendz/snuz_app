class Sleepcasts {
  static String getTitle(String id, String locale) {
    final title = {
      'en': {
        'story_1': 'Forest Walk',
        'story_2': 'Ocean Waves',
        'story_3': 'Summer Rain',
        'story_4': 'Mountain Hike',
        'sos_1': 'Headache Relief',
        'sos_2': 'Stress Relief',
        'sos_3': 'Back Pain Relief',
      },
      'de': {
        'story_1': 'Waldspaziergang',
        'story_2': 'Ozeanwellen',
        'story_3': 'Sommerregen',
        'story_4': 'Bergwandern',
        'sos_1': 'Kopfweh',
        'sos_2': 'Akuter Stress',
        'sos_3': 'Rückenschmerzen',
      },
    };
    return title[locale]?[id] ?? title['en']?[id] ?? '';
  }

  static String getDescription(String id, String locale) {
    final descriptions = {
      'en': {
        'story_1': 'A relaxing walk through a peaceful forest, accompanied by gentle rustling leaves.',
        'story_2': 'Listen to the soothing waves of the ocean on a secluded beach.',
        'story_3': 'A cozy evening at home while gentle summer rain taps against the window.',
        'story_4': 'A peaceful hike through majestic mountains with breathtaking views.',
        'sos_1': 'A guided relaxation with gentle breathing exercises and visualizations for quick headache relief.',
        'sos_2':
            'Quick relief for acute stress through progressive muscle relaxation and calming breathing techniques.',
        'sos_3': 'Targeted relaxation exercises and body awareness for quick back pain relief while lying down.',
      },
      'de': {
        'story_1':
            'Ein entspannender Spaziergang durch einen friedlichen Wald, begleitet vom sanften Rascheln der Blätter.',
        'story_2': 'Lausche den beruhigenden Wellen des Ozeans an einem einsamen Strand.',
        'story_3': 'Ein gemütlicher Abend zuhause, während draußen ein sanfter Sommerregen gegen das Fenster prasselt.',
        'story_4': 'Eine friedvolle Wanderung durch die majestätischen Berge mit atemberaubenden Ausblicken.',
        'sos_1':
            'Eine geführte Entspannung mit sanften Atemübungen und Visualisierungen zur schnellen Schmerzlinderung.',
        'sos_2': 'Schnelle Hilfe bei akutem Stress durch progressive Muskelentspannung und beruhigende Atemtechniken.',
        'sos_3':
            'Gezielte Entspannungsübungen und Körperwahrnehmung zur schnellen Linderung von Rückenschmerzen im Liegen.',
      },
    };

    return descriptions[locale]?[id] ?? descriptions['en']?[id] ?? 'Description not found';
  }
}
