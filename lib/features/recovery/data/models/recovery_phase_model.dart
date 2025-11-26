class RecoveryPhaseModel {
  final String id;
  final String injuryId;
  final int dayStart;
  final int dayEnd;
  final String title;
  final String description;

  RecoveryPhaseModel({
    required this.id,
    required this.injuryId,
    required this.dayStart,
    required this.dayEnd,
    required this.title,
    required this.description,
  });

  factory RecoveryPhaseModel.fromJson(Map<String, dynamic> json) {
    return RecoveryPhaseModel(
      id: json['id'],
      injuryId: json['injury_id'],
      dayStart: json['day_start'],
      dayEnd: json['day_end'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'injury_id': injuryId,
    'day_start': dayStart,
    'day_end': dayEnd,
    'title': title,
    'description': description,
  };
}
