import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class FocusEndpoint extends Endpoint {
  /// Starts a Deep Work session for the given duration (in minutes).
  Future<FocusSession> startSession(Session session, int durationMinutes) async {
    final startTime = DateTime.now();
    final plannedEndTime = startTime.add(Duration(minutes: durationMinutes));

    // 1. Create the session in DB
    final focusSession = FocusSession(
      startTime: startTime,
      plannedEndTime: plannedEndTime,
      isActive: true, // Assuming default is false or we set it here
      slackStatusOriginal: 'Available', // Mock original status capture
    );

    final insertedSession = await FocusSession.db.insertRow(session, focusSession);

    // 2. Mock: Update Slack Status
    session.log('[Mock] Setting Slack Status to: "Deep Work until ${plannedEndTime.toIso8601String()}"');

    // 3. Schedule the Future Call to end the session
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
