import '../../domain/entities/glossary_term.dart';

class GlossaryTermModel {
  final String id;
  final String term;
  final String definition;
  final String example;
  final String category;

  GlossaryTermModel({
    required this.id,
    required this.term,
    required this.definition,
    required this.example,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'term': term,
    'definition': definition,
    'example': example,
    'category': category,
  };

  factory GlossaryTermModel.fromJson(Map<String, dynamic> json) {
    return GlossaryTermModel(
      id: json['id'] as String,
      term: json['term'] as String,
      definition: json['definition'] as String,
      example: json['example'] as String,
      category: json['category'] as String,
    );
  }

  /// Convert model to entity
  GlossaryTerm toEntity() {
    return GlossaryTerm(
      id: id,
      term: term,
      definition: definition,
      example: example,
      category: category,
    );
  }
}
