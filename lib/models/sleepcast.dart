class Sleepcast {
  final String id;
  final String title;
  final String description;
  final String titleDe;
  final String descriptionDe;
  final Duration duration;
  final String audioUrl;

  Sleepcast({
    required this.id,
    required this.title,
    required this.description,
    required this.titleDe,
    required this.descriptionDe,
    required this.duration,
    required this.audioUrl,
  });

  factory Sleepcast.fromJson(Map<String, dynamic> json) {
    return Sleepcast(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      titleDe: json['title_de'] as String,
      descriptionDe: json['description_de'] as String,
      duration: Duration(seconds: json['duration'] as int),
      audioUrl: json['audio_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'title_de': titleDe,
      'description_de': descriptionDe,
      'duration': duration.inSeconds,
      'audio_url': audioUrl,
    };
  }

  Sleepcast copyWith({
    String? id,
    String? title,
    String? description,
    String? titleDe,
    String? descriptionDe,
    Duration? duration,
    String? audioUrl,
  }) {
    return Sleepcast(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      titleDe: titleDe ?? this.titleDe,
      descriptionDe: descriptionDe ?? this.descriptionDe,
      duration: duration ?? this.duration,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }
}
