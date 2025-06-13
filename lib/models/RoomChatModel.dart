import 'package:equatable/equatable.dart';

class RoomChatModel extends Equatable {
  final int roomChatId;
  final String lastMessage;
  final String urlImages;
  final List<int> particicipants;
  final String nameRoom;
  final DateTime createAt;

  const RoomChatModel({
    required this.roomChatId,
    required this.lastMessage,
    required this.urlImages,
    required this.particicipants,
    required this.nameRoom,
    required this.createAt,
  });

  factory RoomChatModel.initial() => RoomChatModel(
        roomChatId: 0,
        lastMessage: '',
        urlImages: '',
        nameRoom: '',
        particicipants: const [],
        createAt: DateTime.fromMillisecondsSinceEpoch(0),
      );

  factory RoomChatModel.fromJson(Map<String, dynamic> json) => RoomChatModel(
        roomChatId: json['roomChatId'] ?? 0,
        lastMessage: json['lastMessage'] ?? '',
        urlImages: json['urlImages'] ?? '',
        nameRoom: json['nameRoom'] ?? '',
        particicipants: List<int>.from(json['particicipants'] ?? []),
        createAt: DateTime.parse(
          json['createAt'] ?? DateTime.now().toIso8601String(),
        ),
      );

  Map<String, dynamic> toJson() => {
        'roomChatId': roomChatId,
        'lastMessage': lastMessage,
        'urlImages': urlImages,
        'nameRoom': nameRoom,
        'particicipants': particicipants,
        'createAt': createAt.toIso8601String(),
      };

  @override
  List<Object> get props =>
      [roomChatId, lastMessage, urlImages, nameRoom, particicipants, createAt];
}
