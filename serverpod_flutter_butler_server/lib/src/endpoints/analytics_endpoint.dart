import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gemini_service.dart';

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

  /// Generates an AI summary of today's completed tasks.
  Future<String> getDailySummary(Session session) async {
    // 1. Fetch completed tasks (mock logic for "today" implies all completed for MVP)
    final tasks = await Task.db.find(
      session,
      where: (t) => t.isCompleted.equals(true),
    );

    if (tasks.isEmpty) {
      return 'No tasks completed yet. Let\'s crush some goals! ⚡️';
    }

    final taskTitles = tasks.map((t) => t.title).toList();

    // 2. Call Gemini Service
    final apiKey = session.serverpod.getPassword('geminiApiKey');
    if (apiKey == null) {
      return 'API Key missing. You did great though!';
    }

    final service = GeminiService(apiKey);
    return await service.generateDailySummary(session, taskTitles);
  }

  /// Fetches all focus sessions for history analysis
  Future<List<FocusSession>> getAllFocusSessions(Session session) async {
    return await FocusSession.db.find(
      session, 
      where: (t) => t.actualEndTime.notEquals(null),
      orderBy: (t) => t.startTime,
      orderDescending: true,
    );
  }
}
