import 'package:serverpod/serverpod.dart';
import 'dart:async';

class TimerEndpoint extends Endpoint {
  /// Starts a streaming timer for the specified duration (in seconds).
  /// Returns a stream of integers representing the seconds remaining.
  Stream<int> startTimer(Session session, int durationSeconds) async* {
    session.log('Client connected to timer stream for $durationSeconds seconds');
    
    for (var i = durationSeconds; i >= 0; i--) {
      // Check if the client has disconnected to stop the loop
      // Note: serverpod streams automatically handle disconnection cancellation usually,
      // but explicit checks or just the yield works.
      
      yield i;
      await Future.delayed(const Duration(seconds: 1));
    }
    
    session.log('Timer stream completed');
  }
}
