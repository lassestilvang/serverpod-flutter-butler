import 'package:flutter/material.dart';
import 'package:serverpod_flutter_butler_client/serverpod_flutter_butler_client.dart';
import 'package:confetti/confetti.dart';
import '../main.dart';
import '../widgets/task_entry_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _refreshKey = 0;
  int? _secondsRemaining;
  int? _activeTaskId; 
  late ConfettiController _confettiController;
  String? _butlerTip;
  bool _isLoadingTip = true;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadButlerTip();
  }

  Future<void> _loadButlerTip() async {
    try {
      final tip = await client.tasks.getButlerTip();
      if (mounted) {
        setState(() {
          _butlerTip = tip;
          _isLoadingTip = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingTip = false);
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, sir.';
    if (hour < 17) return 'Good afternoon, sir.';
    return 'Good evening, sir.';
  }
  
  void _refreshDashboard() {
    _loadButlerTip();
    setState(() {
      _refreshKey++;
    });
  }

  void _startTimer(int taskId) async {
    const duration = 1500; 
    
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
       _confettiController.play();
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pomodoro Completed! 🍅')));
    }
  }

  Future<void> _markCompleted(Task task) async {
    try {
      task.isCompleted = true;
      await client.tasks.updateTask(task);
      _confettiController.play();
      _refreshDashboard();
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
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Butler Dashboard 🎩'),
        elevation: 0,
        actions: [
          IconButton(onPressed: _refreshDashboard, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
          FutureBuilder<List<Task>>(
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
              final activeTasks = allTasks.where((t) => !t.isCompleted).toList();

              if (activeTasks.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.rocket_launch, size: 100, color: Colors.blue),
                          ),
                          const SizedBox(height: 30),
                          Text('Ready to crush the day?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const Text('Your dashboard is clear. Let\'s build a plan.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                          const SizedBox(height: 50),
                          SizedBox(width: 500, child: TaskEntryWidget(onTaskSaved: _refreshDashboard)),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Butler's Corner Section
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade900, Colors.indigo.shade800],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                            ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_getGreeting(), style: const TextStyle(color: Colors.white70, fontSize: 16)),
                              const SizedBox(height: 8),
                              const Text('The Butler\'s Counsel', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              if (_isLoadingTip)
                                const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70))
                              else
                                Text(
                                  _butlerTip ?? 'Consistency is the hallmark of progress, sir.',
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Today\'s Focus (${activeTasks.length})', 
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(height: 16),
                        // Task List
                        for (final task in activeTasks) ...[
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: _activeTaskId == task.id ? Colors.deepPurple.shade50 : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _activeTaskId == task.id ? Colors.deepPurple.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
                                width: _activeTaskId == task.id ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4)
                                )
                              ]
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              leading: IconButton(
                                icon: Icon(
                                  task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: task.isCompleted ? Colors.green : Colors.grey,
                                  size: 30,
                                ),
                                onPressed: () => _markCompleted(task),
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: _activeTaskId == task.id ? FontWeight.bold : FontWeight.w500,
                                  color: _activeTaskId == task.id ? Colors.deepPurple.shade900 : Colors.black87,
                                ),
                              ),
                              subtitle: _activeTaskId == task.id
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.timer_outlined, size: 16, color: Colors.deepPurple),
                                          const SizedBox(width: 6),
                                          Text(
                                            _formatTime(_secondsRemaining ?? 0),
                                            style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  : task.parentTaskId != null ? const Text('Subtask') : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_activeTaskId != task.id)
                                    IconButton(
                                      icon: const Icon(Icons.play_circle_fill, color: Colors.blue, size: 36),
                                      onPressed: () => _startTimer(task.id!),
                                    ),
                                  PopupMenuButton(
                                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(value: 'delete', child: Text('Remove from Plan')),
                                    ],
                                    onSelected: (val) {
                                      if (val == 'delete') _deleteTask(task);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.grey.withOpacity(0.02),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.add_task, color: Colors.blue),
                              SizedBox(width: 10),
                              Text('Quick Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TaskEntryWidget(onTaskSaved: _refreshDashboard),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
