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

abstract class Pomodoro
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = PomodoroTable();

  static const db = PomodoroRepository._();

  @override
  int? id;

  int taskId;

  int taskId;

  _i2.Task? task;

  DateTime startTime;

  DateTime endTime;

  int durationSeconds;

  int interruptionCount;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Pomodoro',
      if (id != null) 'id': id,
      'taskId': taskId,
      'taskId': taskId,
      if (task != null) 'task': task?.toJsonForProtocol(),
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'durationSeconds': durationSeconds,
      'interruptionCount': interruptionCount,
    };
  }

  static PomodoroInclude include({_i2.TaskInclude? task}) {
    return PomodoroInclude._(task: task);
  }

  static PomodoroIncludeList includeList({
    _i1.WhereExpressionBuilder<PomodoroTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PomodoroTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PomodoroTable>? orderByList,
    PomodoroInclude? include,
  }) {
    return PomodoroIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Pomodoro.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Pomodoro.t),
      include: include,
    );
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

class PomodoroUpdateTable extends _i1.UpdateTable<PomodoroTable> {
  PomodoroUpdateTable(super.table);

  _i1.ColumnValue<int, int> taskId(int value) => _i1.ColumnValue(
    table.taskId,
    value,
  );

  _i1.ColumnValue<int, int> taskId(int value) => _i1.ColumnValue(
    table.taskId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startTime(DateTime value) =>
      _i1.ColumnValue(
        table.startTime,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endTime(DateTime value) =>
      _i1.ColumnValue(
        table.endTime,
        value,
      );

  _i1.ColumnValue<int, int> durationSeconds(int value) => _i1.ColumnValue(
    table.durationSeconds,
    value,
  );

  _i1.ColumnValue<int, int> interruptionCount(int value) => _i1.ColumnValue(
    table.interruptionCount,
    value,
  );
}

class PomodoroTable extends _i1.Table<int?> {
  PomodoroTable({super.tableRelation}) : super(tableName: 'pomodoro') {
    updateTable = PomodoroUpdateTable(this);
    taskId = _i1.ColumnInt(
      'taskId',
      this,
    );
    taskId = _i1.ColumnInt(
      'taskId',
      this,
    );
    startTime = _i1.ColumnDateTime(
      'startTime',
      this,
    );
    endTime = _i1.ColumnDateTime(
      'endTime',
      this,
    );
    durationSeconds = _i1.ColumnInt(
      'durationSeconds',
      this,
    );
    interruptionCount = _i1.ColumnInt(
      'interruptionCount',
      this,
    );
  }

  late final PomodoroUpdateTable updateTable;

  late final _i1.ColumnInt taskId;

  late final _i1.ColumnInt taskId;

  _i2.TaskTable? _task;

  late final _i1.ColumnDateTime startTime;

  late final _i1.ColumnDateTime endTime;

  late final _i1.ColumnInt durationSeconds;

  late final _i1.ColumnInt interruptionCount;

  _i2.TaskTable get task {
    if (_task != null) return _task!;
    _task = _i1.createRelationTable(
      relationFieldName: 'task',
      field: Pomodoro.t.taskId,
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
    taskId,
    taskId,
    startTime,
    endTime,
    durationSeconds,
    interruptionCount,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'task') {
      return task;
    }
    return null;
  }
}

class PomodoroInclude extends _i1.IncludeObject {
  PomodoroInclude._({_i2.TaskInclude? task}) {
    _task = task;
  }

  _i2.TaskInclude? _task;

  @override
  Map<String, _i1.Include?> get includes => {'task': _task};

  @override
  _i1.Table<int?> get table => Pomodoro.t;
}

class PomodoroIncludeList extends _i1.IncludeList {
  PomodoroIncludeList._({
    _i1.WhereExpressionBuilder<PomodoroTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Pomodoro.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Pomodoro.t;
}

class PomodoroRepository {
  const PomodoroRepository._();

  final attachRow = const PomodoroAttachRowRepository._();

  /// Returns a list of [Pomodoro]s matching the given query parameters.
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
  Future<List<Pomodoro>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PomodoroTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PomodoroTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PomodoroTable>? orderByList,
    _i1.Transaction? transaction,
    PomodoroInclude? include,
  }) async {
    return session.db.find<Pomodoro>(
      where: where?.call(Pomodoro.t),
      orderBy: orderBy?.call(Pomodoro.t),
      orderByList: orderByList?.call(Pomodoro.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Pomodoro] matching the given query parameters.
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
  Future<Pomodoro?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PomodoroTable>? where,
    int? offset,
    _i1.OrderByBuilder<PomodoroTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PomodoroTable>? orderByList,
    _i1.Transaction? transaction,
    PomodoroInclude? include,
  }) async {
    return session.db.findFirstRow<Pomodoro>(
      where: where?.call(Pomodoro.t),
      orderBy: orderBy?.call(Pomodoro.t),
      orderByList: orderByList?.call(Pomodoro.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Pomodoro] by its [id] or null if no such row exists.
  Future<Pomodoro?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    PomodoroInclude? include,
  }) async {
    return session.db.findById<Pomodoro>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Pomodoro]s in the list and returns the inserted rows.
  ///
  /// The returned [Pomodoro]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Pomodoro>> insert(
    _i1.Session session,
    List<Pomodoro> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Pomodoro>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Pomodoro] and returns the inserted row.
  ///
  /// The returned [Pomodoro] will have its `id` field set.
  Future<Pomodoro> insertRow(
    _i1.Session session,
    Pomodoro row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Pomodoro>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Pomodoro]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Pomodoro>> update(
    _i1.Session session,
    List<Pomodoro> rows, {
    _i1.ColumnSelections<PomodoroTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Pomodoro>(
      rows,
      columns: columns?.call(Pomodoro.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Pomodoro]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Pomodoro> updateRow(
    _i1.Session session,
    Pomodoro row, {
    _i1.ColumnSelections<PomodoroTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Pomodoro>(
      row,
      columns: columns?.call(Pomodoro.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Pomodoro] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Pomodoro?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PomodoroUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Pomodoro>(
      id,
      columnValues: columnValues(Pomodoro.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Pomodoro]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Pomodoro>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PomodoroUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PomodoroTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PomodoroTable>? orderBy,
    _i1.OrderByListBuilder<PomodoroTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Pomodoro>(
      columnValues: columnValues(Pomodoro.t.updateTable),
      where: where(Pomodoro.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Pomodoro.t),
      orderByList: orderByList?.call(Pomodoro.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Pomodoro]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Pomodoro>> delete(
    _i1.Session session,
    List<Pomodoro> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Pomodoro>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Pomodoro].
  Future<Pomodoro> deleteRow(
    _i1.Session session,
    Pomodoro row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Pomodoro>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Pomodoro>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PomodoroTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Pomodoro>(
      where: where(Pomodoro.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PomodoroTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Pomodoro>(
      where: where?.call(Pomodoro.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PomodoroAttachRowRepository {
  const PomodoroAttachRowRepository._();

  /// Creates a relation between the given [Pomodoro] and [Task]
  /// by setting the [Pomodoro]'s foreign key `taskId` to refer to the [Task].
  Future<void> task(
    _i1.Session session,
    Pomodoro pomodoro,
    _i2.Task task, {
    _i1.Transaction? transaction,
  }) async {
    if (pomodoro.id == null) {
      throw ArgumentError.notNull('pomodoro.id');
    }
    if (task.id == null) {
      throw ArgumentError.notNull('task.id');
    }

    var $pomodoro = pomodoro.copyWith(taskId: task.id);
    await session.db.updateRow<Pomodoro>(
      $pomodoro,
      columns: [Pomodoro.t.taskId],
      transaction: transaction,
    );
  }
}
