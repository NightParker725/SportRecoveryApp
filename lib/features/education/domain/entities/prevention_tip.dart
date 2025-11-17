class PreventionTip {
  final String id;
  final String sport;
  final String title;
  final String description;
  final List<String> tips;

  PreventionTip({
    required this.id,
    required this.sport,
    required this.title,
    required this.description,
    required this.tips,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'sport': sport,
    'title': title,
    'description': description,
    'tips': tips,
  };

  factory PreventionTip.fromJson(Map<String, dynamic> json) {
    return PreventionTip(
      id: json['id'] as String,
      sport: json['sport'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tips: List<String>.from(json['tips'] as List? ?? []),
    );
  }
}
