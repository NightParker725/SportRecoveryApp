class Profile {
  String id;
  final String name;
  final String email;
  final String? preferredName;
  final String? profilePicture;

  final DateTime? birthDate;
  final String? sex;
  final double? heightCm;
  final double? weightKg;
  final String? primaryPhysicalActivity;
  final String? complementaryPhysicalActivity;
  final String? physicalActivityFrequency;
  final List<String>? mainGoals;
  final Map<String, dynamic>? injuriesLastYear;

  final DateTime createdAt;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    this.preferredName,
    this.profilePicture,
    this.birthDate,
    this.sex,
    this.heightCm,
    this.weightKg,
    this.primaryPhysicalActivity,
    this.complementaryPhysicalActivity,
    this.physicalActivityFrequency,
    this.mainGoals,
    this.injuriesLastYear,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    if (preferredName != null) 'preferred_name': preferredName,
    if (profilePicture != null) 'profile_picture': profilePicture,
    if (birthDate != null) 'birth_date': birthDate!.toIso8601String(),
    if (sex != null) 'sex': sex,
    if (heightCm != null) 'height_cm': heightCm,
    if (weightKg != null) 'weight_kg': weightKg,
    if (primaryPhysicalActivity != null) 'primary_physical_activity': primaryPhysicalActivity,
    if (complementaryPhysicalActivity != null) 'complementary_physical_activity': complementaryPhysicalActivity,
    if (physicalActivityFrequency != null) 'physical_activity_frequency': physicalActivityFrequency,
    if (mainGoals != null) 'main_goals': mainGoals,
    if (injuriesLastYear != null) 'injuries_last_year': injuriesLastYear,
    'created_at': createdAt.toIso8601String(),
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    preferredName: json['preferred_name'] as String?,
    profilePicture: json['profile_picture'] as String?,
    birthDate: json['birth_date'] == null
        ? null
        : DateTime.parse(json['birth_date'] as String),
    sex: json['sex'] as String?,
    heightCm: (json['height_cm'] as num?)?.toDouble(),
    weightKg: (json['weight_kg'] as num?)?.toDouble(),
    primaryPhysicalActivity: json['primary_physical_activity'] as String?,
    complementaryPhysicalActivity: json['complementary_physical_activity'] as String?,
    physicalActivityFrequency: json['physical_activity_frequency'] as String?,
    mainGoals: (json['main_goals'] as List<dynamic>?)?.map((e) => e as String).toList(),
    injuriesLastYear: json['injuries_last_year'] == null ? null : Map<String, dynamic>.from(json['injuries_last_year'] as Map),
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
    String? preferredName,
    String? profilePicture,
    String? primaryPhysicalActivity,
    String? complementaryPhysicalActivity,
    String? physicalActivityFrequency,
    List<String>? mainGoals,
    Map<String, dynamic>? injuriesLastYear,
    DateTime? createdAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      preferredName: preferredName ?? this.preferredName,
      profilePicture: profilePicture ?? this.profilePicture,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      primaryPhysicalActivity: primaryPhysicalActivity ?? this.primaryPhysicalActivity,
      complementaryPhysicalActivity: complementaryPhysicalActivity ?? this.complementaryPhysicalActivity,
      physicalActivityFrequency: physicalActivityFrequency ?? this.physicalActivityFrequency,
      mainGoals: mainGoals ?? this.mainGoals,
      injuriesLastYear: injuriesLastYear ?? this.injuriesLastYear,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
