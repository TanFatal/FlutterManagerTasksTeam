// "messageId": 10,
//     "senderId": 23,
//     "content": "test thửaassssaa",
//     "timestamp": "2025-06-09T13:49:22",
//     "type": "text",
import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final int messageId;
  final int senderId;
  final String content;
  final String type;
  final DateTime timestamp;

  const MessageModel({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.type,
  });

  factory MessageModel.initial() => MessageModel(
        messageId: 0,
        senderId: 0,
        content: '',
        type: '',
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
      );

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        messageId: json['messageId'] ?? 0,
        senderId: json['senderId'] ?? 0,
        content: json['content'] ?? '',
        type: json['type'] ?? 'text',
        timestamp: DateTime.parse(
          json['timestamp'] ?? DateTime.now().toIso8601String(),
        ),
      );

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'senderId': senderId,
        'content': content,
        'type': type,
        'timestamp': timestamp.toIso8601String(),
      };

  @override
  List<Object> get props => [messageId, senderId, content, type, timestamp];
}
