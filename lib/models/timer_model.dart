class Timer {
  int? id;
  DateTime startTime;
  int duration;

  Timer({this.id, required this.startTime, required this.duration});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'duration': duration,
    };
  }

  factory Timer.fromMap(Map<String, dynamic> map) {
    return Timer(
      id: map['id'],
      startTime: DateTime.parse(map['startTime']),
      duration: map['duration'],
    );
  }
}
