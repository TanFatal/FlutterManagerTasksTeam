import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final int taskId;
  final String taskName;
  final String description;
  final int assigneeId;
  final String status;
  final DateTime dueDate;
  final DateTime createdAt;
  final String priority;

  const TaskModel({
    required this.taskId,
    required this.taskName,
    required this.description,
    required this.assigneeId,
    required this.status,
    required this.dueDate,
    required this.createdAt,
    required this.priority,
  });

  // initial
  factory TaskModel.initial() => TaskModel(
        taskId: 0,
        taskName: '',
        description: '',
        assigneeId: 0,
        status: '',
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
        priority: '',
      );

  // copyWith
  TaskModel copyWith({
    int? taskId,
    String? taskName,
    String? description,
    int? assigneeId,
    String? status,
    DateTime? dueDate,
    DateTime? createdAt,
    String? priority,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      assigneeId: assigneeId ?? this.assigneeId,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
    );
  }

  // fromJson
  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        taskId: json['taskId'] ?? 0,
        taskName: json['taskName'] ?? '',
        description: json['description'] ?? '',
        assigneeId: json['assigneeId'] ?? 0,
        status: json['status'] ?? '',
        dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        priority: json['priority'] ?? '',
      );

  // toJson
  Map<String, dynamic> toJson() => {
        'taskId': taskId,
        'taskName': taskName,
        'description': description,
        'assigneeId': assigneeId,
        'status': status,
        'dueDate': dueDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'priority': priority,
      };

  @override
  List<Object> get props => [
        taskId,
        taskName,
        description,
        assigneeId,
        status,
        dueDate,
        createdAt,
        priority,
      ];
}
