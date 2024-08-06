class Weight {
  int? id;
  DateTime date;
  double weight;

  Weight({this.id, required this.date, required this.weight});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'weight': weight,
    };
  }

  factory Weight.fromMap(Map<String, dynamic> map) {
    return Weight(
      id: map['id'],
      date: DateTime.parse(map['date']),
      weight: map['weight'],
    );
  }
}
