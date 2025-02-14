class Sleepcast {
  final String id;
  final Duration duration;
  final List<String> locale;

  Sleepcast({
    required this.id,
    required this.duration,
    required this.locale,
  });

  factory Sleepcast.fromJson(Map<String, dynamic> json) {
    return Sleepcast(
      id: json['id'] as String,
      duration: Duration(seconds: json['duration'] as int),
      locale: List<String>.from(json['locale']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration.inSeconds,
      'locale': locale,
    };
  }

  Sleepcast copyWith({
    String? id,
    Duration? duration,
    List<String>? locale,
  }) {
    return Sleepcast(
      id: id ?? this.id,
      duration: duration ?? this.duration,
      locale: locale ?? this.locale,
    );
  }
}
