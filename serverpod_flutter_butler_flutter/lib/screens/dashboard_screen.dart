import 'package:flutter/material.dart';
import 'package:serverpod_flutter_butler_client/serverpod_flutter_butler_client.dart';
import 'package:confetti/confetti.dart';
import '../main.dart';
import '../widgets/task_entry_widget.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onStartFocus;
  const DashboardScreen({super.key, this.onStartFocus});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _refreshKey = 0;
  late ConfettiController _confettiController;
  String? _butlerTip;
  bool _isLoadingTip = true;

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _refreshDashboard();
  }

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

  Future<void> _editTask(Task task) async {
    final titleController = TextEditingController(text: task.title);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Edit Task', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: titleController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Task Title',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Save', style: TextStyle(color: Colors.blueAccent)),
            onPressed: () async {
              task.title = titleController.text;
              await client.tasks.updateTask(task);
              Navigator.of(context).pop();
              _refreshDashboard();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('AI Butler', style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 1.2)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _refreshDashboard,
            icon: const Icon(Icons.refresh, color: Colors.white70),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                   const Text('Add New Task', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 20),
                   Expanded(child: TaskEntryWidget(onTaskSaved: () {
                     Navigator.of(context).pop();
                     _refreshDashboard();
                   })),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.8, -0.6),
                radius: 1.5,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF020617),
                ],
              ),
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.blue, Colors.indigo, Colors.cyan],
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

              // Grouping Logic
              final mainTasks = activeTasks.where((t) => t.parentTaskId == null).toList();
              final subTasks = activeTasks.where((t) => t.parentTaskId != null).toList();
              
              // Handle orphans (active subtasks whose parents are completed or missing)
              final mainTaskIds = mainTasks.map((e) => e.id).toSet();
              final orphans = subTasks.where((t) => !mainTaskIds.contains(t.parentTaskId)).toList();
              
              // Create a display list of "Roots" (True Roots + Orphans treated as Roots)
              final displayRoots = [...mainTasks, ...orphans];

              if (displayRoots.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 40, spreadRadius: 10)
                          ],
                          gradient: const LinearGradient(colors: [Colors.blue, Colors.indigo]),
                        ),
                        child: const Icon(Icons.bolt, size: 80, color: Colors.white),
                      ),
                      const SizedBox(height: 40),
                      Text('Ready to excel, sir?', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 10),
                      const Text('Your slate is clean. Let\'s orchestrate your day.', style: TextStyle(color: Colors.white54, fontSize: 16)),
                    ],
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(24, 120, 24, 100),
                children: [
                   // Butler's Counsel - Glassmorphism
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.02),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_getGreeting().toUpperCase(), style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                                const SizedBox(height: 8),
                                const Text('The Butler\'s Counsel', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 32),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Visual Accent - Wave (Mocked with gradient box)
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withOpacity(0),
                                Colors.blueAccent.withOpacity(0.3),
                                Colors.purpleAccent.withOpacity(0.3),
                                Colors.blue.withOpacity(0),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.waves, color: Colors.white.withOpacity(0.2), size: 40),
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (_isLoadingTip)
                          const LinearProgressIndicator()
                        else
                          Text(
                            _butlerTip ?? 'Consistency is the hallmark of excellence, sir.',
                            style: const TextStyle(color: Colors.white70, fontSize: 18, height: 1.6, fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'PRIMARY OBJECTIVES', 
                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 3)
                  ),
                  const SizedBox(height: 24),
                  // Render Task Hierarchy
                  for (final task in displayRoots) ...[
                    _buildTaskCard(task, subTasks.where((s) => s.parentTaskId == task.id).toList()),
                  ]
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, List<Task> subTasks) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Main Task
          ListTile(
            onTap: () => _editTask(task),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            leading: InkWell(
              onTap: () => _markCompleted(task),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: task.isCompleted ? const Icon(Icons.check, size: 20, color: Colors.greenAccent) : null,
              ),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.blueAccent, size: 32),
                  onPressed: () {
                    if (widget.onStartFocus != null && task.id != null) {
                      widget.onStartFocus!(task.id!);
                    }
                  },
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white38),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'delete', child: Text('Delete Task')),
                  ],
                  onSelected: (val) {
                    if (val == 'delete') _deleteTask(task);
                  },
                ),
              ],
            ),
          ),
          
          // Subtasks List
          if (subTasks.isNotEmpty) ...[
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
                color: Colors.black12,
              ),
              child: Column(
                children: subTasks.map((sub) => ListTile(
                  onTap: () => _editTask(sub),
                  dense: true,
                  contentPadding: const EdgeInsets.fromLTRB(60, 0, 16, 0),
                  leading: InkWell(
                    onTap: () => _markCompleted(sub),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1.5),
                      ),
                      child: sub.isCompleted ? const Icon(Icons.check, size: 14, color: Colors.greenAccent) : null,
                    ),
                  ),
                  title: Text(
                    sub.title,
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow_rounded, color: Colors.white24, size: 20),
                    onPressed: () {
                      if (widget.onStartFocus != null && sub.id != null) {
                        widget.onStartFocus!(sub.id!);
                      }
                    },
                  ),
                )).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
