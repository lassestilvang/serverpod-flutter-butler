import 'package:flutter/material.dart';
import '../../main.dart'; // Access to global client

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  Map<String, int>? _stats;
  String? _dailySummary; // Add state for summary
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
      // Fetch summary in parallel or sequence? Sequence for simplicity, or future.wait
      // Let's do sequence to ensure stats load first
      final summary = await client.analytics.getDailySummary();
      
      if (mounted) {
        setState(() {
          _stats = stats;
          _dailySummary = summary;
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
      appBar: AppBar(
        title: const Text('Daily Insights'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildStatCard(
                        'Completed Tasks',
                        _stats?['completedTasks']?.toString() ?? '0',
                        Icons.check_circle_outline,
                        Colors.green,
                      ),
                      const SizedBox(height: 16),
                      _buildStatCard(
                        'Total Focus Time',
                        '${_stats?['totalFocusMinutes'] ?? 0} min',
                        Icons.timer,
                        Colors.blue,
                      ),
                      const SizedBox(height: 32),
                      if (_dailySummary != null)
                        Card(
                          color: Colors.amber.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.auto_awesome, color: Colors.amber),
                                    SizedBox(width: 8),
                                    Text('AI Daily Report', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _dailySummary!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      const Text(
                        'Keep up the momentum! 🚀',
                        style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
