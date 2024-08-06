class Fasting {
  int? id;
  DateTime startTime;
  int fastingHours;

  Fasting({this.id, required this.startTime, required this.fastingHours});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'fastingHours': fastingHours,
    };
  }

  factory Fasting.fromMap(Map<String, dynamic> map) {
    return Fasting(
      id: map['id'],
      startTime: DateTime.parse(map['startTime']),
      fastingHours: map['fastingHours'],
    );
  }
}
