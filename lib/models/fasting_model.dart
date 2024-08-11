class Fasting {
  int? id;
  DateTime startTime;
  DateTime endTime;
  int fastingHours;
  DateTime date;

  Fasting(
      {this.id,
      required this.startTime,
      required this.endTime,
      required this.fastingHours,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'fastingHours': fastingHours,
      'date': date.toIso8601String()
    };
  }

  factory Fasting.fromMap(Map<String, dynamic> map) {
    return Fasting(
        id: map['id'],
        startTime: DateTime.parse(map['startTime']),
        endTime: DateTime.parse(map['endTime']),
        fastingHours: map['fastingHours'],
        date: DateTime.parse(map['date']));
  }
}
