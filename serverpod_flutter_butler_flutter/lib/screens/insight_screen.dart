import 'package:flutter/material.dart';
import 'package:serverpod_flutter_butler_client/serverpod_flutter_butler_client.dart';
import '../../main.dart'; // Access to global client

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  Map<String, int>? _stats;
  String? _dailySummary; 
  List<Task> _completedTasks = []; // Added for list
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await client.analytics.getDailyStats();
      final summary = await client.analytics.getDailySummary();
      // Fetch completion list (re-using all tasks for now, filtering locally)
      final allTasks = await client.tasks.getAllTasks();
      
      if (mounted) {
        setState(() {
          _stats = stats;
          _dailySummary = summary;
          _completedTasks = allTasks.where((t) => t.isCompleted).toList();
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('DAILY INSIGHTS', style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2, fontSize: 16)),
        elevation: 0,
        backgroundColor: Colors.transparent,
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
                    padding: const EdgeInsets.fromLTRB(32, 120, 32, 32),
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
                      Text(
                        'ACCOMPLISHMENTS',
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Column(
                          children: [
                            if (_completedTasks.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Text('No tasks completed yet. Begin your work.', style: TextStyle(color: Colors.white38)),
                              )
                            else
                              for (int i = 0; i < _completedTasks.length; i++)
                                Container(
                                  decoration: i < _completedTasks.length - 1 
                                    ? BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05)))) 
                                    : null,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    leading: const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                                    title: Text(
                                      _completedTasks[i].title, 
                                      style: TextStyle(color: Colors.white.withOpacity(0.8), decoration: TextDecoration.lineThrough, decorationColor: Colors.white24)
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      if (_dailySummary != null) ...[
                        Text(
                          'AI PERFORMANCE REVIEW',
                          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.06),
                                Colors.white.withOpacity(0.01),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.star, color: Colors.amber, size: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text('EXECUTIVE SUMMARY', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text(
                                _dailySummary!,
                                style: TextStyle(fontSize: 17, height: 1.6, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(height: 24),
                              const Divider(color: Colors.white10),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSmallMetric('FOCUS', '+15%'),
                                  _buildSmallMetric('SCORE', '9.8/10'),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 60),
                      Center(
                        child: Text(
                          'MAINTAIN THE MOMENTUM, SIR.',
                          style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 4),
                        ),
                      ),
                    ],
                  ),
                ),
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
