import 'package:bluebird/core/enums/notification_type_enum.dart';

class Notification {
  final String text;
  final String tweetId;
  final String id;
  final String uid;
  final NotificationType notificationType;
  Notification({
    required this.text,
    required this.tweetId,
    required this.id,
    required this.uid,
    required this.notificationType,
  });

  Notification copyWith({
    String? text,
    String? tweetId,
    String? id,
    String? uid,
    NotificationType? notificationType,
  }) {
    return Notification(
      text: text ?? this.text,
      tweetId: tweetId ?? this.tweetId,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'tweetId': tweetId});
    result.addAll({'uid': uid});
    result.addAll({'notificationType': notificationType.type});

    return result;
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      text: map['text'] ?? '',
      tweetId: map['tweetId'] ?? '',
      id: map['\$id'] ?? '',
      uid: map['uid'] ?? '',
      notificationType:
          (map['notificationType'] as String).toNotificationTypeEnum(),
    );
  }

  @override
  String toString() {
    return 'Notification(text: $text, tweetId: $tweetId, id: $id, uid: $uid, notificationType: $notificationType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notification &&
        other.text == text &&
        other.tweetId == tweetId &&
        other.id == id &&
        other.uid == uid &&
        other.notificationType == notificationType;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        tweetId.hashCode ^
        id.hashCode ^
        uid.hashCode ^
        notificationType.hashCode;
  }
}
