import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class FocusEndpoint extends Endpoint {
  /// Starts a Deep Work session for the given duration (in minutes).
  Future<FocusSession> startSession(Session session, int durationMinutes, {int? taskId}) async {
    // 0. Check for existing active session to prevent race conditions
    final existingSession = await FocusSession.db.findFirstRow(
      session,
      where: (t) => t.isActive.equals(true),
    );

    if (existingSession != null) {
      throw Exception('A focus session is already active. Please stop it before starting a new one.');
    }

    final startTime = DateTime.now();
    final plannedEndTime = startTime.add(Duration(minutes: durationMinutes));

    String statusText = 'Deep Working until ${plannedEndTime.toIso8601String()}';
    
    // 1. Fetch task details if provided
    if (taskId != null) {
      final task = await Task.db.findById(session, taskId);
      if (task != null) {
        statusText = 'Focusing on: "${task.title}" 🧠';
      }
    }

    // 2. Create the session in DB
    final focusSession = FocusSession(
      startTime: startTime,
      plannedEndTime: plannedEndTime,
      isActive: true, 
      taskId: taskId,
      slackStatusOriginal: 'Available', 
    );

    final insertedSession = await FocusSession.db.insertRow(session, focusSession);

    // 3. Mock: Update Slack Status
    session.log('[Mock] Setting Slack Status to: "$statusText"');

    // 4. Schedule the Future Call to end the session
    await session.serverpod.futureCallWithDelay(
      'endSessionCall',
      insertedSession,
      Duration(minutes: durationMinutes),
    );

    return insertedSession;
  }

  /// Manually stops the current active session.
  Future<void> stopSession(Session session) async {
    // Find active session
    final activeSession = await FocusSession.db.findFirstRow(
      session,
      where: (t) => t.isActive.equals(true),
    );

    if (activeSession != null) {
      activeSession.isActive = false;
      activeSession.actualEndTime = DateTime.now();
      await FocusSession.db.updateRow(session, activeSession);
      
      session.log('[Manual] Stopped Deep Work Session: ${activeSession.id}');
      // Note: The scheduled Future Call will still run but we can check isActive inside it 
      // or implement cancellation logic if we stored the identifier.
      // For MVP, letting it run and do nothing (or re-update) is acceptable, 
      // but ideally we check if it's already closed.
    }
  }
}
