class Sleepcast {
  final String id;
  final String title;
  final String description;
  final String title_de;
  final String description_de;
  final Duration duration;

  Sleepcast({
    required this.id,
    required this.title,
    required this.description,
    required this.title_de,
    required this.description_de,
    required this.duration,
  });

  factory Sleepcast.fromJson(Map<String, dynamic> json) {
    return Sleepcast(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      title_de: json['title_de'] as String,
      description_de: json['description_de'] as String,
      duration: Duration(seconds: json['duration'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'title_de': title_de,
      'description_de': description_de,
      'duration': duration.inSeconds,
    };
  }

  Sleepcast copyWith({
    String? id,
    String? title,
    String? description,
    String? title_de,
    String? description_de,
    Duration? duration,
  }) {
    return Sleepcast(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      title_de: title_de ?? this.title_de,
      description_de: description_de ?? this.description_de,
      duration: duration ?? this.duration,
    );
  }

  // Hilfsmethoden für lokalisierte Texte
}
