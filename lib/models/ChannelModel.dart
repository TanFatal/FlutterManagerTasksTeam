import 'package:equatable/equatable.dart';

// class ChannelModel extends Equatable {
//   final String channelId;
//   final String groupChatID;
//   final String channelName;
//   final String adminId;
//   final List<String> memberIds;
//   final DateTime createAt;

//   const ChannelModel({
//     required this.channelId,
//     required this.groupChatID,
//     required this.channelName,
//     required this.adminId,
//     required this.memberIds,
//     required this.createAt,
//   });
//   factory ChannelModel.initial() => ChannelModel(
//         channelId: '',
//         channelName: '',
//         groupChatID: '',
//         adminId: '',
//         memberIds: const [''],
//         createAt: DateTime.fromMillisecondsSinceEpoch(0),
//       );

//   //copyWith
//   // ChannelModel copyWith({
//   //   String? channelId,
//   //   String? channelName,
//   //   String? adminId,
//   //   List<String>? memberIds,
//   //   DateTime? createAt,
//   // }) {
//   //   return ChannelModel(
//   //     channelId: channelId ?? this.channelId,
//   //     channelName: channelName ?? this.channelName,
//   //     adminId: adminId ?? this.adminId,
//   //     memberIds: memberIds ?? this.memberIds,
//   //     createAt: createAt ?? this.createAt,
//   //   );
//   // }

//   //fromJson
//   factory ChannelModel.fromJson(Map<String, dynamic> json) => ChannelModel(
//         channelId: json['channelId'] ?? '',
//         groupChatID: json['groupChatID'] ?? '',
//         channelName: json['channelName'] ?? '',
//         adminId: json['adminId'] ?? '',
//         memberIds: List<String>.from(json['memberIds'] ?? []),
//         createAt: DateTime.parse(
//             json['createAt'] ?? DateTime.now().toIso8601String()),
//       );

//   //toJson
//   Map<String, dynamic> toJson() => {
//         'channelId': channelId,
//         'groupChatID': groupChatID,
//         'channelName': channelName,
//         'adminId': adminId,
//         'memberIds': memberIds,
//         'createAt': createAt.toIso8601String(),
//       };

//   @override
//   List<Object> get props =>
//       [channelId, groupChatID, channelName, adminId, memberIds, createAt];
// }
class ChannelModel extends Equatable {
  final int channelId;
  final int groupChatID;
  final String channelName;
  final int adminId;
  final List<int> memberIds;
  final DateTime createAt;

  const ChannelModel({
    required this.channelId,
    required this.groupChatID,
    required this.channelName,
    required this.adminId,
    required this.memberIds,
    required this.createAt,
  });

  factory ChannelModel.initial() => ChannelModel(
        channelId: 0,
        groupChatID: 0,
        channelName: '',
        adminId: 0,
        memberIds: const [],
        createAt: DateTime.fromMillisecondsSinceEpoch(0),
      );

  factory ChannelModel.fromJson(Map<String, dynamic> json) => ChannelModel(
        channelId: json['channelId'] ?? 0,
        groupChatID: json['groupChatID'] ?? 0,
        channelName: json['channelName'] ?? '',
        adminId: json['adminId'] ?? 0,
        memberIds: List<int>.from(json['memberIds'] ?? []),
        createAt: DateTime.parse(
          json['createAt'] ?? DateTime.now().toIso8601String(),
        ),
      );

  Map<String, dynamic> toJson() => {
        'channelId': channelId,
        'groupChatID': groupChatID,
        'channelName': channelName,
        'adminId': adminId,
        'memberIds': memberIds,
        'createAt': createAt.toIso8601String(),
      };

  @override
  List<Object> get props =>
      [channelId, groupChatID, channelName, adminId, memberIds, createAt];
}
