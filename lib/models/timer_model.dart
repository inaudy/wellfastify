class TimerData {
  int? id;
  DateTime startTime;
  int duration;

  TimerData({this.id, required this.startTime, required this.duration});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'duration': duration,
    };
  }

  factory TimerData.fromMap(Map<String, dynamic> map) {
    return TimerData(
      id: map['id'],
      startTime: DateTime.parse(map['startTime']),
      duration: map['duration'],
    );
  }
}
