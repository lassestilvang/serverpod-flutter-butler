import 'package:flutter/material.dart';
import 'package:serverpod_flutter_butler_client/serverpod_flutter_butler_client.dart';
import '../../main.dart'; // Access to global client

class DeepWorkScreen extends StatefulWidget {
  const DeepWorkScreen({super.key});

  @override
  State<DeepWorkScreen> createState() => _DeepWorkScreenState();
}

class _DeepWorkScreenState extends State<DeepWorkScreen> {
  bool _isSessionActive = false;
  String? _statusMessage;
  List<Task> _availableTasks = [];
  int? _selectedTaskId;
  bool _isLoadingTasks = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await client.tasks.getAllTasks();
      if (mounted) {
        setState(() {
          _availableTasks = tasks.where((t) => !t.isCompleted).toList();
          _isLoadingTasks = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingTasks = false);
      }
    }
  }

  Future<void> _startSession() async {
    setState(() {
      _statusMessage = 'Initializing Focus Mode...';
    });

    try {
      // Start a 1 minute session for demo purposes
      await client.focus.startSession(1, taskId: _selectedTaskId);
      setState(() {
        _isSessionActive = true;
        final taskTitle = _availableTasks.firstWhere((t) => t.id == _selectedTaskId, orElse: () => Task(title: 'Deep Work', isCompleted: false, parentTaskId: 0)).title;
        _statusMessage = 'Currently Focusing on:\n"$taskTitle"';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    }
  }

  Future<void> _stopSession() async {
    try {
      await client.focus.stopSession();
      setState(() {
        _isSessionActive = false;
        _statusMessage = 'Session Ended Early.';
      });
      _loadTasks(); // Refresh list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Butler'),
        backgroundColor: _isSessionActive ? Colors.deepPurple.shade900 : null,
        foregroundColor: _isSessionActive ? Colors.white : null,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: _isSessionActive ? BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade900, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isSessionActive ? Icons.nightlight_round : Icons.sunny,
              size: 120,
              color: _isSessionActive ? Colors.amber.shade200 : Colors.orange,
            ),
            const SizedBox(height: 30),
            Text(
              _statusMessage ?? 'Ready to enter Deep Work?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: _isSessionActive ? Colors.white : null,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 40),
            if (!_isSessionActive) ...[
              if (_isLoadingTasks)
                const CircularProgressIndicator()
              else if (_availableTasks.isEmpty)
                const Text('No active tasks to focus on.\nCreate a plan first!', textAlign: TextAlign.center)
              else ...[
                const Text('Choose your main focus:'),
                const SizedBox(height: 10),
                DropdownButton<int>(
                  value: _selectedTaskId,
                  hint: const Text('Select a task'),
                  items: _availableTasks.map((t) {
                    return DropdownMenuItem(value: t.id, child: Text(t.title));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedTaskId = val),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _selectedTaskId == null ? null : _startSession,
                  icon: const Icon(Icons.bolt),
                  label: const Text('Enter Focus Mode'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ] else
              ElevatedButton(
                onPressed: _stopSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
                ),
                child: const Text('End Session Early'),
              ),
          ],
        ),
      ),
    );
  }
}

