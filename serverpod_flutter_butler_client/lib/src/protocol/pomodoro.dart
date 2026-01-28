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

abstract class Pomodoro implements _i1.SerializableModel {
  Pomodoro._({
    this.id,
    required this.taskId,
    required this.taskId,
    this.task,
    required this.startTime,
    required this.endTime,
    required this.durationSeconds,
    required this.interruptionCount,
  });

  factory Pomodoro({
    int? id,
    required int taskId,
    required int taskId,
    _i2.Task? task,
    required DateTime startTime,
    required DateTime endTime,
    required int durationSeconds,
    required int interruptionCount,
  }) = _PomodoroImpl;

  factory Pomodoro.fromJson(Map<String, dynamic> jsonSerialization) {
    return Pomodoro(
      id: jsonSerialization['id'] as int?,
      taskId: jsonSerialization['taskId'] as int,
      task: jsonSerialization['task'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Task>(jsonSerialization['task']),
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      durationSeconds: jsonSerialization['durationSeconds'] as int,
      interruptionCount: jsonSerialization['interruptionCount'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int taskId;

  int taskId;

  _i2.Task? task;

  DateTime startTime;

  DateTime endTime;

  int durationSeconds;

  int interruptionCount;

  /// Returns a shallow copy of this [Pomodoro]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Pomodoro copyWith({
    int? id,
    int? taskId,
    int? taskId,
    _i2.Task? task,
    DateTime? startTime,
    DateTime? endTime,
    int? durationSeconds,
    int? interruptionCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Pomodoro',
      if (id != null) 'id': id,
      'taskId': taskId,
      'taskId': taskId,
      if (task != null) 'task': task?.toJson(),
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'durationSeconds': durationSeconds,
      'interruptionCount': interruptionCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PomodoroImpl extends Pomodoro {
  _PomodoroImpl({
    int? id,
    required int taskId,
    required int taskId,
    _i2.Task? task,
    required DateTime startTime,
    required DateTime endTime,
    required int durationSeconds,
    required int interruptionCount,
  }) : super._(
         id: id,
         taskId: taskId,
         task: task,
         startTime: startTime,
         endTime: endTime,
         durationSeconds: durationSeconds,
         interruptionCount: interruptionCount,
       );

  /// Returns a shallow copy of this [Pomodoro]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Pomodoro copyWith({
    Object? id = _Undefined,
    int? taskId,
    int? taskId,
    Object? task = _Undefined,
    DateTime? startTime,
    DateTime? endTime,
    int? durationSeconds,
    int? interruptionCount,
  }) {
    return Pomodoro(
      id: id is int? ? id : this.id,
      taskId: taskId ?? this.taskId,
      task: task is _i2.Task? ? task : this.task?.copyWith(),
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      interruptionCount: interruptionCount ?? this.interruptionCount,
    );
  }
}
