import 'package:flutter/material.dart';
import 'package:serverpod_flutter_butler_client/serverpod_flutter_butler_client.dart';
import '../main.dart';
import '../widgets/task_entry_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // We use a key to force refresh of the list
  int _refreshKey = 0;

  // Timer State (Lifted from old screen)
  int? _secondsRemaining;
  int? _activeTaskId; // Track by ID now
  
  void _refreshDashboard() {
    setState(() {
      _refreshKey++;
    });
  }

  void _startTimer(int taskId) async {
    const duration = 1500; // 25 mins
    
    setState(() {
      _activeTaskId = taskId;
      _secondsRemaining = duration;
    });

    try {
      final stream = client.timer.startTimer(duration);
      await for (final update in stream) {
        if (!mounted) break;
        setState(() {
          _secondsRemaining = update;
        });
        if (update == 0) {
          _timerComplete();
          break;
        }
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Timer Error: $e')));
      }
    }
  }

  void _timerComplete() {
    setState(() {
      _activeTaskId = null;
      _secondsRemaining = null;
    });
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pomodoro Completed! 🍅')));
    }
  }

  Future<void> _markCompleted(Task task) async {
    try {
      task.isCompleted = true;
      await client.tasks.updateTask(task);
      _refreshDashboard();
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task Completed! 🎉')));
      }
    } catch(e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Err: $e')));
    }
  }

  Future<void> _deleteTask(Task task) async {
     try {
      await client.tasks.deleteTask(task);
      _refreshDashboard();
    } catch(e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Err: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard ☕️'),
        actions: [
          IconButton(onPressed: _refreshDashboard, icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder<List<Task>>(
        key: ValueKey(_refreshKey),
        future: client.tasks.getAllTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allTasks = snapshot.data ?? [];
          // Filter out completed tasks locally for now (endpoint returns all)
          // Also categorize into "Main Plans" (parentTaskId == null) and "Subtasks" if we want
          // For now, let's just show active tasks.
          final activeTasks = allTasks.where((t) => !t.isCompleted).toList();

          if (activeTasks.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text('All caught up! No active tasks.', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 40),
                    SizedBox(width: 600, child: TaskEntryWidget(onTaskSaved: _refreshDashboard)),
                  ],
                ),
              ),
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Panel: Active Tasks
              Expanded(
                flex: 2,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activeTasks.length,
                  itemBuilder: (context, index) {
                    final task = activeTasks[index];
                    final isRunning = _activeTaskId == task.id;

                    return Card(
                      elevation: isRunning ? 6 : 2,
                      color: isRunning ? Colors.green.shade50 : null,
                      shape: isRunning ? RoundedRectangleBorder(side: BorderSide(color: Colors.green, width: 2), borderRadius: BorderRadius.circular(12)) : null,
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isCompleted, 
                          onChanged: (val) => _markCompleted(task),
                          shape: const CircleBorder(),
                        ),
                        title: Text(
                          task.title, 
                          style: TextStyle(
                            fontWeight: isRunning ? FontWeight.bold : FontWeight.normal,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null
                          )
                        ),
                        subtitle: isRunning 
                          ? Text('⏱️ ${_formatTime(_secondsRemaining ?? 0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                          : task.parentTaskId != null ? const Text('Subtask', style: TextStyle(fontSize: 12, color: Colors.grey)) : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(isRunning ? Icons.pause_circle : Icons.play_circle_fill),
                              color: isRunning ? Colors.green : Colors.blue,
                              iconSize: 32,
                              onPressed: isRunning ? null : () => _startTimer(task.id!), // Pause not impl yet
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: 'delete', child: Text('Delete')),
                              ],
                              onSelected: (val) {
                                if (val == 'delete') _deleteTask(task);
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Right Panel: New Plan (Smaller)
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Add Details', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TaskEntryWidget(onTaskSaved: _refreshDashboard),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
