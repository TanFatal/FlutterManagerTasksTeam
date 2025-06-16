import 'package:equatable/equatable.dart';

class ProjectModel extends Equatable {
  final int projectId;
  final int ownerId;
  final String projectName;
  final String description;
  final List<int> members;
  final DateTime endDate;
  final int toDo;
	final int inProgress;
	final int inReview;
	final int done;
  final int taskCount;

  const ProjectModel({
    required this.projectId,
    required this.ownerId,
    required this.projectName,
    required this.description,
    required this.members,
    required this.endDate,
    this.toDo = 0,
    this.inProgress = 0,
    this.inReview = 0,
    this.done = 0,
    this.taskCount = 0,
  });

  factory ProjectModel.initial() => ProjectModel(
        projectId: 0,
        ownerId: 0,
        projectName: '',
        description: '',
        members: const [],
        endDate: DateTime.fromMillisecondsSinceEpoch(0),
        toDo:0,
        inProgress: 0,
        inReview: 0,
        done: 0,
        taskCount: 0,
      );

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        projectId: json['projectId'] ?? 0,
        ownerId: json['ownerId'] ?? 0,
        projectName: json['projectName'] ?? '',
        description: json['description'] ?? '',
        members: List<int>.from(json['memberIds'] ?? []),
        endDate: DateTime.parse(
          json['endDate'] ?? DateTime.now().toIso8601String(),
        ),
        toDo: json['toDo'] ?? 0,
        inProgress: json['inProgress'] ?? 0,
        inReview: json['inReview'] ?? 0,
        done: json['done'] ?? 0,
        taskCount: json['taskCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'projectId': projectId,
        'ownerId': ownerId,
        'projectName': projectName,
        'description': description,
        'memberIds': members,
        'endDate': endDate.toIso8601String(),
        'taskCount': taskCount,
      };

  @override
  List<Object> get props => [
        projectId,
        ownerId,
        projectName,
        description,
        members,
        endDate,
        taskCount
      ];
}
