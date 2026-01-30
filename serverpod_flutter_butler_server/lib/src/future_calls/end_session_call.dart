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

    // 2. Integration Point: Restore Slack Status
    // TODO: Implement actual Slack API integration here using object.slackStatusOriginal
    
    // 3. Integration Point: Generate Focus Summary
    // TODO: Trigger summarization logic
    
    // 4. Integration Point: User Notification
    // TODO: Send push notification or WebSocket event
    session.log('Deep Work Session Completed: ${object.id}. Integrations pending.');
  }
}
