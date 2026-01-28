import 'package:flutter/material.dart';
import 'package:serverpod_flutter_butler_client/serverpod_flutter_butler_client.dart';
import '../main.dart'; // Access to the global 'client'

class TimeBoxScreen extends StatefulWidget {
  const TimeBoxScreen({super.key});

  @override
  State<TimeBoxScreen> createState() => _TimeBoxScreenState();
}

class _TimeBoxScreenState extends State<TimeBoxScreen> {
  final _taskController = TextEditingController();
  bool _isLoading = false;
  List<String> _subtasks = [];
  // Pending implementation of real Task model usage
  // List<Task> _tasks = []; 

  // Timer State
  int? _secondsRemaining;
  int? _activeSubtaskIndex;
  Stream<int>? _timerStream;

  void _startTimer(int index) async {
    // 25 minutes = 1500 seconds
    const duration = 1500;
    
    setState(() {
      _activeSubtaskIndex = index;
      _secondsRemaining = duration;
    });

    try {
      final stream = client.timer.startTimer(duration);
      await for (final update in stream) {
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
      _activeSubtaskIndex = null;
      _secondsRemaining = null;
    });
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pomodoro Completed! 🍅')));
    }
  } 

  Future<void> _breakdownTask() async {
    final input = _taskController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
      _subtasks = [];
    });

    try {
      // Call the server endpoint
      final result = await client.tasks.breakdownTask(input);
      setState(() {
        _subtasks = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createTask() async {
    final title = _taskController.text.trim();
    if (title.isEmpty || _subtasks.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a task and generate subtasks first.')));
        return;
    }

    setState(() => _isLoading = true);

    try {
        // 1. Save Main Task
        final mainTask = Task(
            title: title, 
            isCompleted: false,
        );
        final savedMainTask = await client.tasks.addTask(mainTask);

        // 2. Save Subtasks
        for (final subtaskTitle in _subtasks) {
            final subtask = Task(
                title: subtaskTitle,
                isCompleted: false,
                parentTaskId: savedMainTask.id, 
            );
            await client.tasks.addTask(subtask);
        }
        
        if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan Saved Successfully! 💾')));
             setState(() {
               _taskController.clear();
               _subtasks = [];
             });
        }
    } catch (e) {
        if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving plan: $e')));
        }
    } finally {
        if (mounted) {
            setState(() => _isLoading = false);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeBox Butler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'What is your main task?',
                hintText: 'e.g., Refactor Auth Flow',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: _isLoading ? null : _breakdownTask,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Magic Breakdown'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const LinearProgressIndicator()
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _subtasks.length,
                  itemBuilder: (context, index) {
                    final subtask = _subtasks[index];
                    final isRunning = _activeSubtaskIndex == index;
                    
                    return Card(
                      color: isRunning ? Colors.green.shade50 : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isRunning ? Colors.green : null,
                          foregroundColor: isRunning ? Colors.white : null,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(subtask),
                        subtitle: isRunning 
                            ? Text('Time Remaining: ${_formatTime(_secondsRemaining ?? 0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) 
                            : const Text('Estimated 1 Pomodoro'),
                        trailing: IconButton(
                          icon: Icon(isRunning ? Icons.timer : Icons.play_arrow),
                          color: isRunning ? Colors.green : null,
                          onPressed: isRunning ? null : () => _startTimer(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (_subtasks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: _createTask,
                  child: const Text('Save Plan'),
                ),
              ),
          ],
        ),
      ),
    );
  }
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
