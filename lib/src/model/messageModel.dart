// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessageModel {
  String senderId;
  String receiverId;
  String textMsg;
  String dateTime;
  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.textMsg,
    required this.dateTime,
  });

  MessageModel copyWith({
    String? senderId,
    String? receiverId,
    String? textMsg,
    String? dateTime,
  }) {
    return MessageModel(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      textMsg: textMsg ?? this.textMsg,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'textMsg': textMsg,
      'dateTime': dateTime,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      textMsg: map['textMsg'] as String,
      dateTime: map['dateTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(senderId: $senderId, receiverId: $receiverId, textMsg: $textMsg, dateTime: $dateTime)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.textMsg == textMsg &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return senderId.hashCode ^
        receiverId.hashCode ^
        textMsg.hashCode ^
        dateTime.hashCode;
  }
}
