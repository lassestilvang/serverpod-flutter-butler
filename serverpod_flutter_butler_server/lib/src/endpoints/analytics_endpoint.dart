import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AnalyticsEndpoint extends Endpoint {
  /// Returns a simple summary of daily statistics.
  /// For this MVP, it returns a Map with keys: 'completedTasks', 'totalFocusMinutes'.
  Future<Map<String, int>> getDailyStats(Session session) async {
    // 1. Count completed tasks
    final tasks = await Task.db.find(
      session,
      where: (t) => t.isCompleted.equals(true),
    );
    
    // 2. Calculate total Deep Work duration
    // Fetch all completed focus sessions
    final focusSessions = await FocusSession.db.find(
      session,
      where: (t) => t.isActive.equals(false) & t.actualEndTime.notEquals(null),
    );

    int totalMinutes = 0;
    for (var fs in focusSessions) {
      if (fs.actualEndTime != null) {
        final duration = fs.actualEndTime!.difference(fs.startTime).inMinutes;
        totalMinutes += duration;
      }
    }

    return {
      'completedTasks': tasks.length,
      'totalFocusMinutes': totalMinutes,
    };
  }
}
