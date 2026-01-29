import 'package:flutter/material.dart';
import 'package:serverpod_flutter_butler_client/serverpod_flutter_butler_client.dart';
import '../main.dart';

class TaskEntryWidget extends StatefulWidget {
  final VoidCallback onTaskSaved;

  const TaskEntryWidget({super.key, required this.onTaskSaved});

  @override
  State<TaskEntryWidget> createState() => _TaskEntryWidgetState();
}

class _TaskEntryWidgetState extends State<TaskEntryWidget> {
  final _taskController = TextEditingController();
  bool _isLoading = false;
  List<String> _subtasks = [];

  Future<void> _breakdownTask() async {
    final input = _taskController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
      _subtasks = [];
    });

    try {
      final result = await client.tasks.breakdownTask(input);
      setState(() {
        _subtasks = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        createdAt: DateTime.now(),
      );
      final savedMainTask = await client.tasks.addTask(mainTask);

      // 2. Save Subtasks
      for (final subtaskTitle in _subtasks) {
        final subtask = Task(
          title: subtaskTitle,
          isCompleted: false,
          parentTaskId: savedMainTask.id,
          createdAt: DateTime.now(),
        );
        await client.tasks.addTask(subtask);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan Saved Successfully! 💾')));
        setState(() {
          _taskController.clear();
          _subtasks = [];
        });
        widget.onTaskSaved(); // Notify parent to refresh
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
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Create New Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
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
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _breakdownTask,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Magic Breakdown'),
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading) ...[
               const SizedBox(height: 20),
               const LinearProgressIndicator(),
            ],
            if (_subtasks.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Align(alignment: Alignment.centerLeft, child: Text("Proposed Subtasks:", style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              ..._subtasks.map((s) => ListTile(
                dense: true,
                leading: const Icon(Icons.check_circle_outline, size: 20),
                title: Text(s),
              )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _createTask,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Plan & Start Working'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.blue.shade900
                  )
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
