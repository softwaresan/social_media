// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostModel {
  String postImage;
  String description;
  String dateTime;
  PostModel({
    required this.postImage,
    required this.description,
    required this.dateTime,
  });

  PostModel copyWith({
    String? postImage,
    String? description,
    String? dateTime,
  }) {
    return PostModel(
      postImage: postImage ?? this.postImage,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postImage': postImage,
      'description': description,
      'dateTime': dateTime,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postImage: map['postImage'] as String,
      description: map['description'] as String,
      dateTime: map['dateTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PostModel(postImage: $postImage, description: $description, dateTime: $dateTime)';

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.postImage == postImage &&
        other.description == description &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode =>
      postImage.hashCode ^ description.hashCode ^ dateTime.hashCode;
}
