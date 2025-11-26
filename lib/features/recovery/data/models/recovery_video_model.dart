import 'package:moviles252/features/recovery/domain/entities/recovery_video.dart';

class RecoveryVideoModel extends RecoveryVideo {
  RecoveryVideoModel({
    required String id,
    required String title,
    required String url,
    String? thumbnailUrl,
    List<String>? recommendations,
  }) : super(
         id: id,
         title: title,
         url: url,
         thumbnailUrl: thumbnailUrl,
         recommendations: recommendations ?? [],
       );

  factory RecoveryVideoModel.fromJson(Map<String, dynamic> json) {
    final recs =
        (json['recommendations'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];
    return RecoveryVideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      recommendations: recs,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'url': url,
    'thumbnail_url': thumbnailUrl,
    'recommendations': recommendations,
  };
}
