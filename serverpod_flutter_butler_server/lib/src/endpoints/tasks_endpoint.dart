import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gemini_service.dart';

class TasksEndpoint extends Endpoint {
  /// Fetches all tasks from the database.
  Future<List<Task>> getAllTasks(Session session) async {
    return await Task.db.find(session);
  }

  /// Adds a new task to the database.
  Future<Task> addTask(Session session, Task task) async {
    return await Task.db.insertRow(session, task);
  }

  /// Updates an existing task in the database.
  Future<Task> updateTask(Session session, Task task) async {
    return await Task.db.updateRow(session, task);
  }

  /// Deletes a task from the database.
  Future<bool> deleteTask(Session session, Task task) async {
    // Delete the task and return true if successful.
    // Note: serverpod deleteRow returns the deleted row, so we check if it's not null (although insert/update returns the object).
    // Actually deleteRow returns Future<T>.
    await Task.db.deleteRow(session, task);
    return true;
  }

  /// Breaks down a complex task into subtasks using Gemini AI.
  Future<List<String>> breakdownTask(Session session, String description) async {
    final apiKey = session.serverpod.getPassword('geminiApiKey');
    if (apiKey == null) {
      throw Exception('Gemini API Key not found in server passwords.');
    }
    
    final service = GeminiService(apiKey);
    return await service.breakDownTask(session, description);
  }
}
