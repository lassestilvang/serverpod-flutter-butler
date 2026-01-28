import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class EndSessionCall extends FutureCall<FocusSession> {
  @override
  Future<void> invoke(Session session, FocusSession? object) async {
    if (object == null) {
      session.log('EndSessionCall invoked without data', level: LogLevel.error);
      return;
    }

    session.log('Ending Deep Work Session: ${object.id}');

    // 1. Mark session as complete in DB
    object.isActive = false;
    object.actualEndTime = DateTime.now();
    await FocusSession.db.updateRow(session, object);

    // 2. Mock: Restore Slack Status
    // In a real app, we would use object.slackStatusOriginal to restore.
    session.log('[Mock] Restoring Slack Status to: "${object.slackStatusOriginal ?? 'Active'}"');

    // 3. Generate Focus Summary (Placeholder for Phase 4)
    session.log('[Mock] Generating Focus Summary...');
    
    // 4. Notify User (Placeholder for WebSocket/Push)
    session.log('[Mock] Notification: Deep Work Session Completed!');
  }
}
