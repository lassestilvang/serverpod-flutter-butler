/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'task.dart' as _i2;
import 'package:serverpod_flutter_butler_client/src/protocol/protocol.dart'
    as _i3;

abstract class FocusSession implements _i1.SerializableModel {
  FocusSession._({
    this.id,
    required this.startTime,
    required this.plannedEndTime,
    this.actualEndTime,
    required this.isActive,
    this.taskId,
    this.task,
    this.slackStatusOriginal,
  });

  factory FocusSession({
    int? id,
    required DateTime startTime,
    required DateTime plannedEndTime,
    DateTime? actualEndTime,
    required bool isActive,
    int? taskId,
    _i2.Task? task,
    String? slackStatusOriginal,
  }) = _FocusSessionImpl;

  factory FocusSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return FocusSession(
      id: jsonSerialization['id'] as int?,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      plannedEndTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['plannedEndTime'],
      ),
      actualEndTime: jsonSerialization['actualEndTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['actualEndTime'],
            ),
      isActive: jsonSerialization['isActive'] as bool,
      taskId: jsonSerialization['taskId'] as int?,
      task: jsonSerialization['task'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Task>(jsonSerialization['task']),
      slackStatusOriginal: jsonSerialization['slackStatusOriginal'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime startTime;

  DateTime plannedEndTime;

  DateTime? actualEndTime;

  bool isActive;

  int? taskId;

  _i2.Task? task;

  String? slackStatusOriginal;

  /// Returns a shallow copy of this [FocusSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FocusSession copyWith({
    int? id,
    DateTime? startTime,
    DateTime? plannedEndTime,
    DateTime? actualEndTime,
    bool? isActive,
    int? taskId,
    _i2.Task? task,
    String? slackStatusOriginal,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FocusSession',
      if (id != null) 'id': id,
      'startTime': startTime.toJson(),
      'plannedEndTime': plannedEndTime.toJson(),
      if (actualEndTime != null) 'actualEndTime': actualEndTime?.toJson(),
      'isActive': isActive,
      if (taskId != null) 'taskId': taskId,
      if (task != null) 'task': task?.toJson(),
      if (slackStatusOriginal != null)
        'slackStatusOriginal': slackStatusOriginal,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FocusSessionImpl extends FocusSession {
  _FocusSessionImpl({
    int? id,
    required DateTime startTime,
    required DateTime plannedEndTime,
    DateTime? actualEndTime,
    required bool isActive,
    int? taskId,
    _i2.Task? task,
    String? slackStatusOriginal,
  }) : super._(
         id: id,
         startTime: startTime,
         plannedEndTime: plannedEndTime,
         actualEndTime: actualEndTime,
         isActive: isActive,
         taskId: taskId,
         task: task,
         slackStatusOriginal: slackStatusOriginal,
       );

  /// Returns a shallow copy of this [FocusSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FocusSession copyWith({
    Object? id = _Undefined,
    DateTime? startTime,
    DateTime? plannedEndTime,
    Object? actualEndTime = _Undefined,
    bool? isActive,
    Object? taskId = _Undefined,
    Object? task = _Undefined,
    Object? slackStatusOriginal = _Undefined,
  }) {
    return FocusSession(
      id: id is int? ? id : this.id,
      startTime: startTime ?? this.startTime,
      plannedEndTime: plannedEndTime ?? this.plannedEndTime,
      actualEndTime: actualEndTime is DateTime?
          ? actualEndTime
          : this.actualEndTime,
      isActive: isActive ?? this.isActive,
      taskId: taskId is int? ? taskId : this.taskId,
      task: task is _i2.Task? ? task : this.task?.copyWith(),
      slackStatusOriginal: slackStatusOriginal is String?
          ? slackStatusOriginal
          : this.slackStatusOriginal,
    );
  }
}
