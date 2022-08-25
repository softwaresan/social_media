// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostModel {
  String postImage;
  String description;
  String dateTime;
  String uId;
  String postId;
  PostModel({
    required this.postImage,
    required this.description,
    required this.dateTime,
    required this.uId,
    required this.postId,
  });

  PostModel copyWith({
    String? postImage,
    String? description,
    String? dateTime,
    String? uId,
    String? postId,
  }) {
    return PostModel(
      postImage: postImage ?? this.postImage,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      uId: uId ?? this.uId,
      postId: postId ?? this.postId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postImage': postImage,
      'description': description,
      'dateTime': dateTime,
      'uId': uId,
      'postId': postId,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postImage: map['postImage'] as String,
      description: map['description'] as String,
      dateTime: map['dateTime'] as String,
      uId: map['uId'] as String,
      postId: map['postId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(postImage: $postImage, description: $description, dateTime: $dateTime, uId: $uId, postId: $postId)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.postImage == postImage &&
        other.description == description &&
        other.dateTime == dateTime &&
        other.uId == uId &&
        other.postId == postId;
  }

  @override
  int get hashCode {
    return postImage.hashCode ^
        description.hashCode ^
        dateTime.hashCode ^
        uId.hashCode ^
        postId.hashCode;
  }
}
