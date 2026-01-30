import 'package:flutter/material.dart';
import 'package:serverpod_flutter_butler_client/serverpod_flutter_butler_client.dart';
import 'package:confetti/confetti.dart';
import '../main.dart';
import '../widgets/task_entry_widget.dart';
import '../widgets/butler_app_bar.dart';
import '../controllers/dashboard_controller.dart';
import '../gen/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onStartFocus;
  const DashboardScreen({super.key, this.onStartFocus});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ConfettiController _confettiController;
  final _controller = DashboardController();
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.silentRefresh();
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _controller.loadAllData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _confettiController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _controller.loadMore();
    }
  }


  Future<void> _addSubtask(Task parent) async {
    final titleController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(l10n.addSubtaskTo(parent.title), style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: titleController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: l10n.subtaskTitle,
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
          ),
          onSubmitted: (val) {
             _controller.addTask(val, parentId: parent.id);
             Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(l10n.add, style: const TextStyle(color: Colors.blueAccent)),
            onPressed: () {
              _controller.addTask(titleController.text, parentId: parent.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _editTask(Task task) async {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController(text: task.title);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(l10n.editTask, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: titleController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: l10n.taskTitle,
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
          ),
          onSubmitted: (val) {
             _controller.editTask(task, val);
             Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(l10n.save, style: const TextStyle(color: Colors.blueAccent)),
            onPressed: () {
               _controller.editTask(task, titleController.text);
               Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  String _getLocalizedGreeting(BuildContext context) {
    final type = _controller.getGreetingType();
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return 'HELLO, SIR';
    
    switch (type) {
      case GreetingType.morning: return l10n.goodMorning;
      case GreetingType.afternoon: return l10n.goodAfternoon;
      case GreetingType.evening: return l10n.goodEvening;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ButlerAppBar(
        title: 'AI Butler',
        actions: [
          IconButton(
            onPressed: _controller.loadAllData,
            icon: const Icon(Icons.refresh, color: Colors.white70),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           final l10n = AppLocalizations.of(context)!;
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
                   Text(l10n.addNewTask, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 20),
                   Expanded(child: TaskEntryWidget(onTaskSaved: () {
                     Navigator.of(context).pop();
                     _controller.silentRefresh();
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
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              if (_controller.isLoading && _controller.allTasks.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_controller.error != null && _controller.allTasks.isEmpty) {
                 return Center(child: Text('Error: ${_controller.error}', style: const TextStyle(color: Colors.red)));
              }

              final tasks = _controller.allTasks;
              final activeTasks = tasks.where((t) => !t.isCompleted).toList();

              // Grouping Logic
              final mainTasks = activeTasks.where((t) => t.parentTaskId == null).toList();
              final subTasksList = activeTasks.where((t) => t.parentTaskId != null).toList();
              
              // Handle orphans (active subtasks whose parents are completed or missing)
              final mainTaskIds = mainTasks.map((e) => e.id).toSet();
              final orphans = subTasksList.where((t) => !mainTaskIds.contains(t.parentTaskId)).toList();
              
              // Create a display list of "Roots" (True Roots + Orphans treated as Roots)
              final displayRoots = [...mainTasks, ...orphans];

              if (displayRoots.isEmpty) {
                final l10n = AppLocalizations.of(context)!;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.blue.withValues(alpha: 0.2), blurRadius: 40, spreadRadius: 10)
                          ],
                          gradient: const LinearGradient(colors: [Colors.blue, Colors.indigo]),
                        ),
                        child: const Icon(Icons.bolt, size: 80, color: Colors.white),
                      ),
                      const SizedBox(height: 40),
                      Text(l10n.readyToExcel, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 10),
                      Text(l10n.cleanSlate, style: const TextStyle(color: Colors.white54, fontSize: 16)),
                    ],
                  ),
                );
              }

              final l10n = AppLocalizations.of(context)!;
              return ListView(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 80, 24, 100),
                children: [
                   // Butler's Counsel - Glassmorphism
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.08),
                          Colors.white.withValues(alpha: 0.02),
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
                                Text(_getLocalizedGreeting(context).toUpperCase(), style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                                const SizedBox(height: 8),
                                Text(l10n.butlersCounsel, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 32),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Visual Accent - Wave
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withValues(alpha: 0),
                                Colors.blueAccent.withValues(alpha: 0.3),
                                Colors.purpleAccent.withValues(alpha: 0.3),
                                Colors.blue.withValues(alpha: 0),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.waves, color: Colors.white.withValues(alpha: 0.2), size: 40),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _controller.butlerTip ?? l10n.defaultTip,
                          style: const TextStyle(color: Colors.white70, fontSize: 18, height: 1.6, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    l10n.primaryObjectives, 
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 3)
                  ),
                  const SizedBox(height: 24),
                  // Render Task Hierarchy
                  for (final task in displayRoots) ...[
                    _buildTaskCard(task, subTasksList.where((s) => s.parentTaskId == task.id).toList()),
                  ],
                  if (_controller.hasMore)
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: CircularProgressIndicator(color: Colors.white30)),
                    ),
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
              onTap: () async {
                 _confettiController.play();
                 await _controller.markCompleted(task);
              },
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
                  itemBuilder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return [
                      PopupMenuItem(value: 'add_sub', child: Text(l10n.addSubtask)),
                      PopupMenuItem(value: 'delete', child: Text(l10n.deleteTask)),
                    ];
                  },
                  onSelected: (val) {
                    if (val == 'add_sub') _addSubtask(task);
                    if (val == 'delete') _controller.deleteTask(task);
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
                    onTap: () async {
                      _confettiController.play();
                      await _controller.markCompleted(sub);
                    },
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 18),
                        onPressed: () => _controller.deleteTask(sub),
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white24, size: 20),
                        onPressed: () {
                          if (widget.onStartFocus != null && sub.id != null) {
                            widget.onStartFocus!(sub.id!);
                          }
                        },
                      ),
                    ],
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
