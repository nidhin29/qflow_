import 'dart:convert';

class NotificationModel {
  final String id;
  final String userId;
  final String text;
  final DateTime date;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.text,
    required this.date,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      id: (data['_id'] ?? data['id'] ?? '').toString(),
      userId: (data['user_id'] ?? data['userId'] ?? '').toString(),
      text: (data['text'] ?? data['message'] ?? '').toString(),
      date: data['date'] != null 
          ? DateTime.parse(data['date'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user_id': userId,
      'text': text,
      'date': date.toIso8601String(),
    };
  }

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());
}
