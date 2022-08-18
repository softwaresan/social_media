// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class PublicPosts {
//   String profileImg;
//   String userName;
//   String dateTime;
//   String postImage;
//   String description;
//   PublicPosts({
//     required this.profileImg,
//     required this.userName,
//     required this.dateTime,
//     required this.postImage,
//     required this.description,
//   });

//   PublicPosts copyWith({
//     String? profileImg,
//     String? userName,
//     String? dateTime,
//     String? postImage,
//     String? description,
//   }) {
//     return PublicPosts(
//       profileImg: profileImg ?? this.profileImg,
//       userName: userName ?? this.userName,
//       dateTime: dateTime ?? this.dateTime,
//       postImage: postImage ?? this.postImage,
//       description: description ?? this.description,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'profileImg': profileImg,
//       'userName': userName,
//       'dateTime': dateTime,
//       'postImage': postImage,
//       'description': description,
//     };
//   }

//   factory PublicPosts.fromMap(Map<String, dynamic> map) {
//     return PublicPosts(
//       profileImg: map['profileImg'] as String,
//       userName: map['userName'] as String,
//       dateTime: map['dateTime'] as String,
//       postImage: map['postImage'] as String,
//       description: map['description'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory PublicPosts.fromJson(String source) =>
//       PublicPosts.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'PublicPosts(profileImg: $profileImg, userName: $userName, dateTime: $dateTime, postImage: $postImage, description: $description)';
//   }

//   @override
//   bool operator ==(covariant PublicPosts other) {
//     if (identical(this, other)) return true;

//     return other.profileImg == profileImg &&
//         other.userName == userName &&
//         other.dateTime == dateTime &&
//         other.postImage == postImage &&
//         other.description == description;
//   }

//   @override
//   int get hashCode {
//     return profileImg.hashCode ^
//         userName.hashCode ^
//         dateTime.hashCode ^
//         postImage.hashCode ^
//         description.hashCode;
//   }
// }
