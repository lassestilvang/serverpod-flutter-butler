import 'package:flutter/material.dart';
import 'package:serverpod_flutter_butler_client/serverpod_flutter_butler_client.dart';
import '../main.dart'; // Access to global client
import '../widgets/butler_app_bar.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  Map<String, int>? _stats;
  String? _dailySummary; 
  bool _isLoading = true;
  String? _error;
  
  // Data for History
  List<Task> _allTasks = [];
  List<FocusSession> _allSessions = [];
  Map<int, int> _taskFocusMinutes = {};

  // Formatter for dates
  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  void didUpdateWidget(InsightScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadStats();
  }

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await client.analytics.getDailyStats();
      final summary = await client.analytics.getDailySummary();
      final allTasks = await client.tasks.getAllTasks();
      final sessions = await client.analytics.getAllFocusSessions();
      
      // Calculate Focus Minutes per Task
      final durationMap = <int, int>{};
      for (var s in sessions) {
        if (s.taskId != null && s.actualEndTime != null) {
          final minutes = s.actualEndTime!.difference(s.startTime).inMinutes;
          durationMap[s.taskId!] = (durationMap[s.taskId!] ?? 0) + minutes;
        }
      }

      if (mounted) {
        setState(() {
          _stats = stats;
          _dailySummary = summary;
          _allTasks = allTasks;
          _allSessions = sessions;
          _taskFocusMinutes = durationMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logic for Hierarchy Tree (Completed Only + Completed Subtasks)
    final tasks = _allTasks ?? [];
    final completedTasks = tasks.where((t) => t.isCompleted).toList();
    // We want to group by "Roots". A completed task is a root if:
    // 1. It has no parent.
    // 2. OR its parent is NOT completed (orphaned completion).
    // EXCEPT: If parent is NOT completed, but we want to show context, maybe we show "Part of [Parent]".
    
    // Simpler View: List all COMPLETED items, but nest subtasks under their parents if the parent is ALSO completed.
    // If parent is not completed, show as separate card with label.
    
    final completedRoots = completedTasks.where((t) {
        if (t.parentTaskId == null) return true;
        // Check if parent is also in completedTasks
        return !completedTasks.any((p) => p.id == t.parentTaskId);
    }).toList();
    
    // Sort by recent completion
    completedRoots.sort((a, b) => (b.completedAt ?? DateTime.now()).compareTo(a.completedAt ?? DateTime.now()));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const ButlerAppBar(
        title: 'Daily Insights',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.8, -0.6),
                      radius: 1.5,
                      colors: [
                        Color(0xFF0F172A),
                        Color(0xFF020617),
                      ],
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 120, 24, 32),
                    children: [
                      Text(
                        'PERFORMANCE SUMMARY',
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildExecutiveStatCard(
                              'COMPLETED',
                              _stats?['completedTasks']?.toString() ?? '0',
                              '80% ON TRACK',
                              [Colors.blueAccent, Colors.purpleAccent],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildExecutiveStatCard(
                              'FOCUS TIME',
                              '${_stats?['totalFocusMinutes'] ?? 0}m',
                              'TOP TIER',
                              [Colors.orangeAccent, Colors.redAccent],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      // COMPLETED TASKS LIST SECTION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ACCOMPLISHMENTS LOG',
                            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3),
                          ),
                          Icon(Icons.history, color: Colors.white.withOpacity(0.4), size: 16),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (completedRoots.isEmpty)
                         Padding(
                           padding: const EdgeInsets.all(32.0),
                           child: Center(child: Text('Log is empty. Initiate work.', style: TextStyle(color: Colors.white38, letterSpacing: 1))),
                         )
                      else
                         Column(
                           children: completedRoots.map((root) {
                             // Find children valid for this root (also completed)
                             final children = completedTasks.where((t) => t.parentTaskId == root.id).toList();
                             return _buildHistoryCard(root, children);
                           }).toList(),
                         ),

                      const SizedBox(height: 48),
                      // ... (AI Summary preserved below)
                    ],
                  ),
                ),
    );
  }

  Widget _buildHistoryCard(Task task, List<Task> children) {
    final focusMinutes = _taskFocusMinutes[task.id] ?? 0;
    
    // If logic: Parent logic
    String? contributingLabel;
    if (task.parentTaskId != null) {
      final parent = _allTasks.firstWhere((t) => t.id == task.parentTaskId, orElse: () => Task(title: 'Unknown', isCompleted: false, createdAt: DateTime.now()));
      contributingLabel = parent.title;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: Colors.greenAccent.withOpacity(0.8), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (contributingLabel != null)
                        Text(
                          'PART OF: $contributingLabel',
                          style: TextStyle(color: Colors.blueAccent.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        task.title,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      // Meta Data Row
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          _buildMetaData(Icons.calendar_today, 'Created: ${_formatDate(task.createdAt)}'),
                          _buildMetaData(Icons.event_available, 'Done: ${_formatDate(task.completedAt)}'),
                          _buildMetaData(Icons.timer, 'Focus: ${focusMinutes}m'),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Children
          if (children.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: children.map((child) {
                   final childFocus = _taskFocusMinutes[child.id] ?? 0;
                   return Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     child: Row(
                       children: [
                         const SizedBox(width: 24), // Indent
                         Icon(Icons.subdirectory_arrow_right, color: Colors.white.withOpacity(0.3), size: 16),
                         const SizedBox(width: 8),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(child.title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                               const SizedBox(height: 2),
                               Text(
                                 'Done: ${_formatDate(child.completedAt)} • Focus: ${childFocus}m',
                                 style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10),
                               ),
                             ],
                           ),
                         )
                       ],
                     ),
                   );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildMetaData(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.white38),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white38, fontSize: 11)),
      ],
    );
  }

  Widget _buildExecutiveStatCard(String title, String value, String subtext, List<Color> glowColors) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w200, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          // Mini Glow Chart Mock
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(colors: glowColors),
              boxShadow: [
                BoxShadow(color: glowColors[0].withOpacity(0.5), blurRadius: 8, spreadRadius: 1)
              ]
            ),
          ),
          const SizedBox(height: 12),
          Text(subtext, style: TextStyle(color: glowColors[0].withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSmallMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
