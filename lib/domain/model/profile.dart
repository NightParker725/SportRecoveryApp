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
    // Use the DB column 'name' for the display name; prefer `preferredName` if provided
    'name': preferredName ?? name,
    'email': email,
    if (profilePicture != null) 'profile_picture': profilePicture,
    if (birthDate != null)
      'birth_date': birthDate!.toIso8601String().split('T').first,
    // Map sex to DB allowed values: 'M', 'F', 'O'. Default to 'O' if missing/unknown.
    'sex': _mapSex(sex),
    if (heightCm != null) 'height_cm': heightCm,
    if (weightKg != null) 'weight_kg': weightKg,
    if (primaryPhysicalActivity != null)
      'primary_physical_activity': primaryPhysicalActivity,
    if (complementaryPhysicalActivity != null)
      'complementary_physical_activity': complementaryPhysicalActivity,
    if (physicalActivityFrequency != null)
      'physical_activity_frequency': physicalActivityFrequency,
    if (mainGoals != null) 'main_goals': mainGoals,
    // injuries are stored in a separate table; keep this field for backward compatibility but don't send it by default
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
        : _parseBirthDate(json['birth_date']),
    sex: json['sex'] as String?,
    heightCm: (json['height_cm'] as num?)?.toDouble(),
    weightKg: (json['weight_kg'] as num?)?.toDouble(),
    primaryPhysicalActivity: json['primary_physical_activity'] as String?,
    complementaryPhysicalActivity:
        json['complementary_physical_activity'] as String?,
    physicalActivityFrequency: json['physical_activity_frequency'] as String?,
    mainGoals: (json['main_goals'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    injuriesLastYear: json['injuries_last_year'] == null
        ? null
        : Map<String, dynamic>.from(json['injuries_last_year'] as Map),
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  static DateTime _parseBirthDate(dynamic raw) {
    // Expecting { 'year': n, 'month': n, 'date': n }
    if (raw is Map) {
      final y = raw['year'] as int? ?? (raw['year'] as num?)?.toInt();
      final m = raw['month'] as int? ?? (raw['month'] as num?)?.toInt();
      final d = raw['date'] as int? ?? (raw['date'] as num?)?.toInt();
      if (y != null && m != null && d != null) return DateTime(y, m, d);
    }
    // Fallback: try parsing as ISO string
    try {
      return DateTime.parse(raw as String);
    } catch (_) {
      return DateTime.now();
    }
  }

  // Map various representations to the DB allowed single-letter codes.
  // Accepts: 'M', 'F', 'O' or 'male', 'female', 'other' (case-insensitive).
  // Defaults to 'O' when null or unknown to satisfy DB CHECK constraints.
  static String _mapSex(String? sex) {
    if (sex == null) return 'O';
    final s = sex.trim().toLowerCase();
    if (s == 'm' || s == 'male') return 'M';
    if (s == 'f' || s == 'female') return 'F';
    if (s == 'o' || s == 'other') return 'O';
    // If it's already a single allowed letter
    if (s == 'm' || s == 'f' || s == 'o') return s.toUpperCase();
    // Fallback to 'O'
    return 'O';
  }

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
      primaryPhysicalActivity:
          primaryPhysicalActivity ?? this.primaryPhysicalActivity,
      complementaryPhysicalActivity:
          complementaryPhysicalActivity ?? this.complementaryPhysicalActivity,
      physicalActivityFrequency:
          physicalActivityFrequency ?? this.physicalActivityFrequency,
      mainGoals: mainGoals ?? this.mainGoals,
      injuriesLastYear: injuriesLastYear ?? this.injuriesLastYear,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
