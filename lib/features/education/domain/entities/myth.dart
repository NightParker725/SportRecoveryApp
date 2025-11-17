class Myth {
  final String id;
  final String myth;
  final String reality;
  final String explanation;

  Myth({
    required this.id,
    required this.myth,
    required this.reality,
    required this.explanation,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'myth': myth,
    'reality': reality,
    'explanation': explanation,
  };

  factory Myth.fromJson(Map<String, dynamic> json) {
    return Myth(
      id: json['id'] as String,
      myth: json['myth'] as String,
      reality: json['reality'] as String,
      explanation: json['explanation'] as String,
    );
  }
}
