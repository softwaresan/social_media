// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SocialUser {
  String name;
  String email;
  String phone;
  String? uid;
  String profileImg;
  String coverImg;
  String bio;
  SocialUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.uid,
    required this.profileImg,
    required this.coverImg,
    required this.bio,
  });

  SocialUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? uid,
    String? profileImg,
    String? coverImg,
    String? bio,
  }) {
    return SocialUser(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      uid: uid ?? this.uid,
      profileImg: profileImg ?? this.profileImg,
      coverImg: coverImg ?? this.coverImg,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'uid': uid,
      'profileImg': profileImg,
      'coverImg': coverImg,
      'bio': bio,
    };
  }

  factory SocialUser.fromMap(Map<String, dynamic> map) {
    return SocialUser(
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      uid: map['uid'] as String,
      profileImg: map['profileImg'] as String,
      coverImg: map['coverImg'] as String,
      bio: map['bio'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialUser.fromJson(String source) =>
      SocialUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SocialUser(name: $name, email: $email, phone: $phone, uid: $uid, profileImg: $profileImg, coverImg: $coverImg, bio: $bio)';
  }

  @override
  bool operator ==(covariant SocialUser other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.uid == uid &&
        other.profileImg == profileImg &&
        other.coverImg == coverImg &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        uid.hashCode ^
        profileImg.hashCode ^
        coverImg.hashCode ^
        bio.hashCode;
  }
}
