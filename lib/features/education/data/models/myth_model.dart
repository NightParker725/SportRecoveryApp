import '../../domain/entities/myth.dart';

class MythModel {
  final String id;
  final String myth;
  final String reality;
  final String explanation;

  MythModel({
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

  factory MythModel.fromJson(Map<String, dynamic> json) {
    return MythModel(
      id: json['id'] as String,
      myth: json['myth'] as String,
      reality: json['reality'] as String,
      explanation: json['explanation'] as String,
    );
  }

  /// Convert model to entity
  Myth toEntity() {
    return Myth(
      id: id,
      myth: myth,
      reality: reality,
      explanation: explanation,
    );
  }
}
