// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SocialUser {
  String name;
  String email;
  String phone;
  String? uid;
  SocialUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.uid,
  });

  SocialUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? uid,
  }) {
    return SocialUser(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'uid': uid,
    };
  }

  factory SocialUser.fromMap(Map<String, dynamic> map) {
    return SocialUser(
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialUser.fromJson(String source) =>
      SocialUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SocialUser(name: $name, email: $email, phone: $phone, uid: $uid)';
  }

  @override
  bool operator ==(covariant SocialUser other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ phone.hashCode ^ uid.hashCode;
  }
}
