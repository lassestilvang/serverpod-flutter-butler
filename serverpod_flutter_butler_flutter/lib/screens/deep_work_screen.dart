import 'package:flutter/material.dart';
import 'package:serverpod_flutter_butler_client/serverpod_flutter_butler_client.dart';
import '../main.dart'; // Access to global client
import '../widgets/butler_app_bar.dart';

class DeepWorkScreen extends StatefulWidget {
  final int? initialTaskId;
  const DeepWorkScreen({super.key, this.initialTaskId});

  @override
  State<DeepWorkScreen> createState() => _DeepWorkScreenState();
}

class _DeepWorkScreenState extends State<DeepWorkScreen> {
  bool _isSessionActive = false;
  String? _statusMessage;
  List<Task> _availableTasks = [];
  int? _selectedTaskId;
  bool _isLoadingTasks = true;
  double _sessionDurationMinutes = 45;
  int? _secondsRemaining;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    if (widget.initialTaskId != null) {
      _selectedTaskId = widget.initialTaskId;
    }
  }

  @override
  void didUpdateWidget(DeepWorkScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadTasks(); // Refresh list whenever widget updates (e.g. tab switch in MainScreen)
    if (widget.initialTaskId != null && widget.initialTaskId != oldWidget.initialTaskId) {
      setState(() {
        _selectedTaskId = widget.initialTaskId;
      });
    }
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
      final durationSeconds = (_sessionDurationMinutes * 60).toInt();
      // Start session on server (mocked duration for now on server-side if needed, or pass it)
      // Assuming server API takes minutes or we stick to local + server sync start
      await client.focus.startSession(durationSeconds ~/ 60, taskId: _selectedTaskId); // API uses minutes
      
      setState(() {
        _isSessionActive = true;
        _secondsRemaining = durationSeconds;
        final taskTitle = _availableTasks.firstWhere((t) => t.id == _selectedTaskId, orElse: () => Task(title: 'Deep Work', isCompleted: false, parentTaskId: 0, createdAt: DateTime.now())).title;
        _statusMessage = 'Currently Focusing on:\n"$taskTitle"';
      });

      _runLocalTimer();

    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    }
  }

  void _runLocalTimer() async {
    final stream = client.timer.startTimer(_secondsRemaining!);
    await for (final update in stream) {
      if (!mounted || !_isSessionActive) break;
      setState(() {
        _secondsRemaining = update;
      });
      if (update == 0) {
        _stopSession(completed: true);
        break;
      }
    }
  }

  Future<void> _stopSession({bool completed = false}) async {
    try {
      await client.focus.stopSession();
    } catch(e) { /* ignore */ }
    
    if (mounted) {
      setState(() {
        _isSessionActive = false;
        _statusMessage = completed ? 'Session Completed. Well done.' : 'Session Ended Early.';
        _secondsRemaining = null;
      });
      _loadTasks(); 
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ButlerAppBar(
        title: _isSessionActive ? '' : 'Focus Orchestrator',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.3),
            radius: 1.2,
            colors: _isSessionActive 
              ? [const Color(0xFF2E1065), const Color(0xFF020617)]
              : [const Color(0xFF0F172A), const Color(0xFF020617)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glowing Timer Circle / Aura
            Stack(
              alignment: Alignment.center,
              children: [
                if (_isSessionActive)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) {
                      return Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purpleAccent.withOpacity(0.1 * value),
                              blurRadius: 60 * value,
                              spreadRadius: 20 * value,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white10, width: 1),
                    color: Colors.white.withOpacity(0.02),
                  ),
                  child: Center(
                    child: _isSessionActive 
                      ? Text(_formatTime(_secondsRemaining ?? 0), style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w200, color: Colors.white, letterSpacing: -2))
                      : Icon(Icons.blur_on, size: 80, color: Colors.blueAccent.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Text(
              _isSessionActive ? 'CONCENTRATION IN PROGRESS' : 'READY TO ASCEND?',
              style: TextStyle(
                color: _isSessionActive ? Colors.purpleAccent.withOpacity(0.8) : Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _statusMessage ?? 'Enter a state of deep focus.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w300,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),
            if (!_isSessionActive) ...[
              if (_isLoadingTasks)
                const CircularProgressIndicator(color: Colors.blueAccent)
              else if ((_availableTasks ?? []).isEmpty)
                const Text('No active tasks to focus on.', style: TextStyle(color: Colors.white38))
              else ...[
                // Custom Task Selector (Glassmorphism)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: (_availableTasks ?? []).any((t) => t.id == _selectedTaskId) ? _selectedTaskId : null,
                      dropdownColor: const Color(0xFF0F172A),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      hint: const Text('Select a focus area', style: TextStyle(color: Colors.white38)),
                      items: (_availableTasks ?? []).map((t) {
                        final isSubtask = t.parentTaskId != null;
                        return DropdownMenuItem(
                          value: t.id, 
                          child: Text(isSubtask ? '  ↳ ${t.title}' : t.title),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedTaskId = val),
                    ),
                  ),
                ),
                
                // DATA CONTEXT: Show Parent or Subtasks
                if (_selectedTaskId != null) ...[
                   Builder(
                     builder: (context) {
                       final selectedTask = (_availableTasks ?? []).firstWhere((t) => t.id == _selectedTaskId);
                       final parentId = selectedTask.parentTaskId;
                       final parentTask = parentId != null 
                           ? (_availableTasks ?? []).firstWhere((t) => t.id == parentId, orElse: () => Task(title: 'Unknown Parent', isCompleted: false, parentTaskId: 0, createdAt: DateTime.now())) 
                           : null;
                       
                       // Find subtasks if this is a parent
                       final subtasks = (_availableTasks ?? []).where((t) => t.parentTaskId == selectedTask.id).toList();

                       return Column(
                         children: [
                           if (parentTask != null && parentTask.title != 'Unknown Parent') ...[
                             const SizedBox(height: 16),
                             Container(
                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                               decoration: BoxDecoration(
                                 color: Colors.blueAccent.withOpacity(0.1),
                                 borderRadius: BorderRadius.circular(12),
                                 border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
                               ),
                               child: Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   const Icon(Icons.account_tree_outlined, color: Colors.blueAccent, size: 16),
                                   const SizedBox(width: 8),
                                   Text('CONTRIBUTING TO: ${parentTask.title.toUpperCase()}', style: const TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                 ],
                               ),
                             ),
                           ],
                           if (subtasks.isNotEmpty) ...[
                             const SizedBox(height: 16),
                             Container(
                               padding: const EdgeInsets.all(16),
                               decoration: BoxDecoration(
                                 color: Colors.white.withOpacity(0.03),
                                 borderRadius: BorderRadius.circular(16),
                               ),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text('SUB-OBJECTIVES (${subtasks.length})', style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                   const SizedBox(height: 8),
                                   ...subtasks.map((s) => Padding(
                                     padding: const EdgeInsets.symmetric(vertical: 4),
                                     child: Row(
                                        children: [
                                          const Icon(Icons.circle, size: 6, color: Colors.white24),
                                          const SizedBox(width: 8),
                                          Text(s.title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                        ],
                                     ),
                                   )),
                                 ],
                               ),
                             )
                           ]
                         ],
                       );
                     }
                   ),
                ],

                const SizedBox(height: 24),
                // Duration Slider
                 Column(
                  children: [
                    Text(
                      'DURATION: ${_sessionDurationMinutes.toInt()} MINUTES',
                      style: const TextStyle(color: Colors.blueAccent, letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.blueAccent,
                        inactiveTrackColor: Colors.white10,
                        thumbColor: Colors.white,
                        overlayColor: Colors.blueAccent.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: _sessionDurationMinutes,
                        min: 5,
                        max: 120,
                        divisions: 23,
                        onChanged: (val) => setState(() => _sessionDurationMinutes = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _selectedTaskId == null ? null : _startSession,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: _selectedTaskId == null 
                        ? const LinearGradient(colors: [Colors.white10, Colors.white10])
                        : const LinearGradient(colors: [Colors.blueAccent, Colors.indigoAccent]),
                      boxShadow: _selectedTaskId == null ? [] : [
                        BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))
                      ],
                    ),
                    child: const Text('IGNITE FOCUS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  ),
                ),
              ],
            ] else
              TextButton(
                onPressed: () => _stopSession(completed: false),
                child: const Text('ABORT MISSION', style: TextStyle(color: Colors.white24, letterSpacing: 2, fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }
}

