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

abstract class Task implements _i1.SerializableModel {
  Task._({
    this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.parentTaskId,
    this.parentTask,
  });

  factory Task({
    int? id,
    required String title,
    String? description,
    required bool isCompleted,
    required int parentTaskId,
    _i2.Task? parentTask,
  }) = _TaskImpl;

  factory Task.fromJson(Map<String, dynamic> jsonSerialization) {
    return Task(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      isCompleted: jsonSerialization['isCompleted'] as bool,
      parentTaskId: jsonSerialization['parentTaskId'] as int,
      parentTask: jsonSerialization['parentTask'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Task>(
              jsonSerialization['parentTask'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String? description;

  bool isCompleted;

  int parentTaskId;

  _i2.Task? parentTask;

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? parentTaskId,
    _i2.Task? parentTask,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Task',
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'isCompleted': isCompleted,
      'parentTaskId': parentTaskId,
      if (parentTask != null) 'parentTask': parentTask?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskImpl extends Task {
  _TaskImpl({
    int? id,
    required String title,
    String? description,
    required bool isCompleted,
    required int parentTaskId,
    _i2.Task? parentTask,
  }) : super._(
         id: id,
         title: title,
         description: description,
         isCompleted: isCompleted,
         parentTaskId: parentTaskId,
         parentTask: parentTask,
       );

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Task copyWith({
    Object? id = _Undefined,
    String? title,
    Object? description = _Undefined,
    bool? isCompleted,
    int? parentTaskId,
    Object? parentTask = _Undefined,
  }) {
    return Task(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      parentTask: parentTask is _i2.Task?
          ? parentTask
          : this.parentTask?.copyWith(),
    );
  }
}
