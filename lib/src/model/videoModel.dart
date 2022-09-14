// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VideoModel {
  String videoUrl;
  String description;
  String uid;
  String videoId;
  VideoModel({
    required this.videoUrl,
    required this.description,
    required this.uid,
    required this.videoId,
  });

  VideoModel copyWith({
    String? videoUrl,
    String? description,
    String? uid,
    String? videoId,
  }) {
    return VideoModel(
      videoUrl: videoUrl ?? this.videoUrl,
      description: description ?? this.description,
      uid: uid ?? this.uid,
      videoId: videoId ?? this.videoId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'videoUrl': videoUrl,
      'description': description,
      'uid': uid,
      'videoId': videoId,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      videoUrl: map['videoUrl'] as String,
      description: map['description'] as String,
      uid: map['uid'] as String,
      videoId: map['videoId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VideoModel(videoUrl: $videoUrl, description: $description, uid: $uid, videoId: $videoId)';
  }

  @override
  bool operator ==(covariant VideoModel other) {
    if (identical(this, other)) return true;

    return other.videoUrl == videoUrl &&
        other.description == description &&
        other.uid == uid &&
        other.videoId == videoId;
  }

  @override
  int get hashCode {
    return videoUrl.hashCode ^
        description.hashCode ^
        uid.hashCode ^
        videoId.hashCode;
  }
}
