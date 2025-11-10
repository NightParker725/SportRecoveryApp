class DailyCheckin {
  final String id;
  final String userId;
  final DateTime date;
  final int q1;
  final List<String> q2;
  final List<String> q3;
  final int q4;
  final String? q5;
  final String q6;

  DailyCheckin({
    required this.id,
    required this.userId,
    required this.date,
    required this.q1,
    required this.q2,
    required this.q3,
    required this.q4,
    this.q5,
    required this.q6,
  });

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "date": date.toIso8601String().split("T").first,
    "q1": q1,
    "q2": q2,
    "q3": q3,
    "q4": q4,
    "q5": q5,
    "q6": q6,
  };

  factory DailyCheckin.fromJson(Map<String, dynamic> json) {
    return DailyCheckin(
      id: json["id"],
      userId: json["user_id"],
      date: DateTime.parse(json["date"]),
      q1: json["q1"],
      q2: List<String>.from(json["q2"] ?? []),
      q3: List<String>.from(json["q3"] ?? []),
      q4: json["q4"],
      q5: json["q5"],
      q6: json["q6"],
    );
  }
}
