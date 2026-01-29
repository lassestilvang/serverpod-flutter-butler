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
        title: const Text('Daily Insights 📉'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade700],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(24.0),
                    children: [
                      Text(
                        'Your Performance',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Completed',
                              _stats?['completedTasks']?.toString() ?? '0',
                              Icons.check_circle,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Focus Time',
                              '${_stats?['totalFocusMinutes'] ?? 0}m',
                              Icons.bolt,
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      if (_dailySummary != null) ...[
                        Text(
                          'Butler\'s Summary',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                            ],
                            border: Border.all(color: Colors.amber.withOpacity(0.3), width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.auto_awesome, color: Colors.amber, size: 28),
                                  SizedBox(width: 12),
                                  Text('AI Performance Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _dailySummary!,
                                style: const TextStyle(fontSize: 17, height: 1.5, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 48),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.rocket_launch, size: 48, color: Colors.blue.withOpacity(0.2)),
                            const SizedBox(height: 12),
                            const Text(
                              'Keep up the momentum, sir.',
                              style: TextStyle(fontSize: 18, color: Colors.grey, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 5))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
