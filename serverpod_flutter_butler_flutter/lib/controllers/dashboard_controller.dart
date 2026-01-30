import 'package:flutter/foundation.dart';
import 'package:serverpod_flutter_butler_client/serverpod_flutter_butler_client.dart';
import '../main.dart';

enum GreetingType { morning, afternoon, evening }

class DashboardController extends ChangeNotifier {
  // ... (previous fields)
  List<Task> allTasks = [];
  String? butlerTip;
  bool isLoading = true;
  String? error;

  // ... (previous methods)

  GreetingType getGreetingType() {
    final hour = DateTime.now().hour;
    if (hour < 12) return GreetingType.morning;
    if (hour < 17) return GreetingType.afternoon;
    return GreetingType.evening;
  }
  bool hasMore = true;
  int _offset = 0;
  static const int _limit = 20;

  Future<void> loadAllData({bool refresh = false}) async {
    if (refresh) {
      isLoading = true;
      _offset = 0;
      allTasks.clear();
      hasMore = true;
      notifyListeners();
    }
    
    if (!hasMore) return;

    try {
      final newTasks = await client.tasks.getAllTasks(limit: _limit, offset: _offset);
      
      if (refresh) {
         // Only fetch tip on full refresh
         butlerTip = await client.tasks.getButlerTip();
      }

      if (newTasks.length < _limit) {
        hasMore = false;
      }
      
      allTasks.addAll(newTasks);
      _offset += newTasks.length;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoading || !hasMore) return;
    await loadAllData(refresh: false);
  }

  Future<void> silentRefresh() async {
    // For now, silent refresh just re-fetches the first page to keep it simple, 
    // or we'd need complex merging logic. 
    // Let's reload everything silently to ensure consistency for this MVP phase.
    try {
       final tasks = await client.tasks.getAllTasks(limit: _offset > 0 ? _offset : _limit, offset: 0);
       allTasks = tasks;
       notifyListeners();
    } catch (e) {
      // Silent error
    }
  }


  Future<void> markCompleted(Task task) async {
    // Optimistic Update
    allTasks.removeWhere((t) => t.id == task.id);
    notifyListeners();

    try {
      task.isCompleted = true;
      task.completedAt = DateTime.now();
      await client.tasks.updateTask(task);
      await silentRefresh();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      await silentRefresh(); // Revert/Sync on error
    }
  }

  Future<void> deleteTask(Task task) async {
    // Optimistic Update
    allTasks.removeWhere((t) => t.id == task.id || t.parentTaskId == task.id);
    notifyListeners();

    try {
      await client.tasks.deleteTask(task);
      await silentRefresh();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      await silentRefresh();
    }
  }

  Future<void> addTask(String title, {int? parentId}) async {
    if (title.isEmpty) return;
    
    // We can't easily optimistically add because we need the ID for edit/delete
    // But we can add a temp one? For now, let's just wait, it's fast.
    // Or we could trigger a loading state if we want.
    
    try {
      final newTask = Task(
        title: title,
        isCompleted: false,
        parentTaskId: parentId,
        createdAt: DateTime.now(),
      );
      final created = await client.tasks.addTask(newTask);
      allTasks.add(created);
      notifyListeners();
      // No need for full refresh if we just append, but silentRefresh cleans up everything
      await silentRefresh(); 
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> editTask(Task task, String newTitle) async {
     try {
       task.title = newTitle;
       await client.tasks.updateTask(task);
       await silentRefresh();
     } catch (e) {
       error = e.toString();
       notifyListeners();
     }
  }
}
