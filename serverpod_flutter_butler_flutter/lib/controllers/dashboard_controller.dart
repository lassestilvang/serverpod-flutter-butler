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
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _fetchData();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> silentRefresh() async {
    try {
      await _fetchData();
      notifyListeners();
    } catch (e) {
      // Silent error
    }
  }

  Future<void> _fetchData() async {
    final tasks = await client.tasks.getAllTasks();
    final tip = await client.tasks.getButlerTip();
    allTasks = tasks;
    butlerTip = tip;
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
