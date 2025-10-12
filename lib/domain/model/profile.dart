class Profile {
  String id;
  final String name;
  final String email;

  final DateTime? birthDate;
  final String? sex;
  final double? heightCm;
  final double? weightKg;

  final DateTime createdAt;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    this.birthDate,
    this.sex,
    this.heightCm,
    this.weightKg,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    if (birthDate != null) 'birth_date': birthDate!.toIso8601String(),
    if (sex != null) 'sex': sex,
    if (heightCm != null) 'height_cm': heightCm,
    if (weightKg != null) 'weight_kg': weightKg,
    'created_at': createdAt.toIso8601String(),
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    birthDate: json['birth_date'] == null
        ? null
        : DateTime.parse(json['birth_date'] as String),
    sex: json['sex'] as String?,
    heightCm: (json['height_cm'] as num?)?.toDouble(),
    weightKg: (json['weight_kg'] as num?)?.toDouble(),
    createdAt: DateTime.parse(json['created_at'] as String),
  );
  Profile copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? birthDate,
    String? sex,
    double? heightCm,
    double? weightKg,
    DateTime? createdAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
