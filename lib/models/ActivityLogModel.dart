import 'package:equatable/equatable.dart';

class ActivityLog extends Equatable {
  final int activityId;
  final int taskId;
  final String taskName;
  final int userActionId;
  final String action;
  final DateTime timestamp;

  const ActivityLog({
    required this.activityId,
    required this.taskId,
    required this.taskName,
    required this.userActionId,
    required this.action,
    required this.timestamp,
  });

  factory ActivityLog.initial() => ActivityLog(
        activityId: 0,
        taskId: 0,
        taskName: '',
        userActionId: 0,
        action: '',
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
      );

  factory ActivityLog.fromJson(Map<String, dynamic> json) => ActivityLog(
        activityId: json['activityId'] ?? 0,
        taskId: json['taskId'] ?? 0,
        taskName: json['taskName'] ?? '',
        userActionId: json['userActionId'] ?? 0,
        action: json['action'] ?? '',
        timestamp: DateTime.parse(
          json['timestamp'] ?? DateTime.now().toIso8601String(),
        ),
      );

  Map<String, dynamic> toJson() => {
        'activityId': activityId,
        'taskId': taskId,
        'taskName': taskName,
        'userActionId': userActionId,
        'action': action,
        'timestamp': timestamp.toIso8601String(),
      };

  @override
  List<Object> get props =>
      [activityId, taskId, taskName, userActionId, action, timestamp];
}
