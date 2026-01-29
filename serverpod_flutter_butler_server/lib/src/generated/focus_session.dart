/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'task.dart' as _i2;
import 'package:serverpod_flutter_butler_server/src/generated/protocol.dart'
    as _i3;

abstract class FocusSession
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = FocusSessionTable();

  static const db = FocusSessionRepository._();

  @override
  int? id;

  DateTime startTime;

  DateTime plannedEndTime;

  DateTime? actualEndTime;

  bool isActive;

  int? taskId;

  _i2.Task? task;

  String? slackStatusOriginal;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FocusSession',
      if (id != null) 'id': id,
      'startTime': startTime.toJson(),
      'plannedEndTime': plannedEndTime.toJson(),
      if (actualEndTime != null) 'actualEndTime': actualEndTime?.toJson(),
      'isActive': isActive,
      if (taskId != null) 'taskId': taskId,
      if (task != null) 'task': task?.toJsonForProtocol(),
      if (slackStatusOriginal != null)
        'slackStatusOriginal': slackStatusOriginal,
    };
  }

  static FocusSessionInclude include({_i2.TaskInclude? task}) {
    return FocusSessionInclude._(task: task);
  }

  static FocusSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<FocusSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FocusSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FocusSessionTable>? orderByList,
    FocusSessionInclude? include,
  }) {
    return FocusSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FocusSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FocusSession.t),
      include: include,
    );
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

class FocusSessionUpdateTable extends _i1.UpdateTable<FocusSessionTable> {
  FocusSessionUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> startTime(DateTime value) =>
      _i1.ColumnValue(
        table.startTime,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> plannedEndTime(DateTime value) =>
      _i1.ColumnValue(
        table.plannedEndTime,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> actualEndTime(DateTime? value) =>
      _i1.ColumnValue(
        table.actualEndTime,
        value,
      );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<int, int> taskId(int? value) => _i1.ColumnValue(
    table.taskId,
    value,
  );

  _i1.ColumnValue<String, String> slackStatusOriginal(String? value) =>
      _i1.ColumnValue(
        table.slackStatusOriginal,
        value,
      );
}

class FocusSessionTable extends _i1.Table<int?> {
  FocusSessionTable({super.tableRelation}) : super(tableName: 'focus_session') {
    updateTable = FocusSessionUpdateTable(this);
    startTime = _i1.ColumnDateTime(
      'startTime',
      this,
    );
    plannedEndTime = _i1.ColumnDateTime(
      'plannedEndTime',
      this,
    );
    actualEndTime = _i1.ColumnDateTime(
      'actualEndTime',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    taskId = _i1.ColumnInt(
      'taskId',
      this,
    );
    slackStatusOriginal = _i1.ColumnString(
      'slackStatusOriginal',
      this,
    );
  }

  late final FocusSessionUpdateTable updateTable;

  late final _i1.ColumnDateTime startTime;

  late final _i1.ColumnDateTime plannedEndTime;

  late final _i1.ColumnDateTime actualEndTime;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnInt taskId;

  _i2.TaskTable? _task;

  late final _i1.ColumnString slackStatusOriginal;

  _i2.TaskTable get task {
    if (_task != null) return _task!;
    _task = _i1.createRelationTable(
      relationFieldName: 'task',
      field: FocusSession.t.taskId,
      foreignField: _i2.Task.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.TaskTable(tableRelation: foreignTableRelation),
    );
    return _task!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    startTime,
    plannedEndTime,
    actualEndTime,
    isActive,
    taskId,
    slackStatusOriginal,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'task') {
      return task;
    }
    return null;
  }
}

class FocusSessionInclude extends _i1.IncludeObject {
  FocusSessionInclude._({_i2.TaskInclude? task}) {
    _task = task;
  }

  _i2.TaskInclude? _task;

  @override
  Map<String, _i1.Include?> get includes => {'task': _task};

  @override
  _i1.Table<int?> get table => FocusSession.t;
}

class FocusSessionIncludeList extends _i1.IncludeList {
  FocusSessionIncludeList._({
    _i1.WhereExpressionBuilder<FocusSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FocusSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FocusSession.t;
}

class FocusSessionRepository {
  const FocusSessionRepository._();

  final attachRow = const FocusSessionAttachRowRepository._();

  final detachRow = const FocusSessionDetachRowRepository._();

  /// Returns a list of [FocusSession]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<FocusSession>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FocusSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FocusSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FocusSessionTable>? orderByList,
    _i1.Transaction? transaction,
    FocusSessionInclude? include,
  }) async {
    return session.db.find<FocusSession>(
      where: where?.call(FocusSession.t),
      orderBy: orderBy?.call(FocusSession.t),
      orderByList: orderByList?.call(FocusSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [FocusSession] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<FocusSession?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FocusSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<FocusSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FocusSessionTable>? orderByList,
    _i1.Transaction? transaction,
    FocusSessionInclude? include,
  }) async {
    return session.db.findFirstRow<FocusSession>(
      where: where?.call(FocusSession.t),
      orderBy: orderBy?.call(FocusSession.t),
      orderByList: orderByList?.call(FocusSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [FocusSession] by its [id] or null if no such row exists.
  Future<FocusSession?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    FocusSessionInclude? include,
  }) async {
    return session.db.findById<FocusSession>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [FocusSession]s in the list and returns the inserted rows.
  ///
  /// The returned [FocusSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<FocusSession>> insert(
    _i1.Session session,
    List<FocusSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FocusSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [FocusSession] and returns the inserted row.
  ///
  /// The returned [FocusSession] will have its `id` field set.
  Future<FocusSession> insertRow(
    _i1.Session session,
    FocusSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FocusSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FocusSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FocusSession>> update(
    _i1.Session session,
    List<FocusSession> rows, {
    _i1.ColumnSelections<FocusSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FocusSession>(
      rows,
      columns: columns?.call(FocusSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FocusSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FocusSession> updateRow(
    _i1.Session session,
    FocusSession row, {
    _i1.ColumnSelections<FocusSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FocusSession>(
      row,
      columns: columns?.call(FocusSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FocusSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FocusSession?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<FocusSessionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FocusSession>(
      id,
      columnValues: columnValues(FocusSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FocusSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FocusSession>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FocusSessionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FocusSessionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FocusSessionTable>? orderBy,
    _i1.OrderByListBuilder<FocusSessionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FocusSession>(
      columnValues: columnValues(FocusSession.t.updateTable),
      where: where(FocusSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FocusSession.t),
      orderByList: orderByList?.call(FocusSession.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FocusSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FocusSession>> delete(
    _i1.Session session,
    List<FocusSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FocusSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FocusSession].
  Future<FocusSession> deleteRow(
    _i1.Session session,
    FocusSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FocusSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FocusSession>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FocusSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FocusSession>(
      where: where(FocusSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FocusSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FocusSession>(
      where: where?.call(FocusSession.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class FocusSessionAttachRowRepository {
  const FocusSessionAttachRowRepository._();

  /// Creates a relation between the given [FocusSession] and [Task]
  /// by setting the [FocusSession]'s foreign key `taskId` to refer to the [Task].
  Future<void> task(
    _i1.Session session,
    FocusSession focusSession,
    _i2.Task task, {
    _i1.Transaction? transaction,
  }) async {
    if (focusSession.id == null) {
      throw ArgumentError.notNull('focusSession.id');
    }
    if (task.id == null) {
      throw ArgumentError.notNull('task.id');
    }

    var $focusSession = focusSession.copyWith(taskId: task.id);
    await session.db.updateRow<FocusSession>(
      $focusSession,
      columns: [FocusSession.t.taskId],
      transaction: transaction,
    );
  }
}

class FocusSessionDetachRowRepository {
  const FocusSessionDetachRowRepository._();

  /// Detaches the relation between this [FocusSession] and the [Task] set in `task`
  /// by setting the [FocusSession]'s foreign key `taskId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> task(
    _i1.Session session,
    FocusSession focusSession, {
    _i1.Transaction? transaction,
  }) async {
    if (focusSession.id == null) {
      throw ArgumentError.notNull('focusSession.id');
    }

    var $focusSession = focusSession.copyWith(taskId: null);
    await session.db.updateRow<FocusSession>(
      $focusSession,
      columns: [FocusSession.t.taskId],
      transaction: transaction,
    );
  }
}
