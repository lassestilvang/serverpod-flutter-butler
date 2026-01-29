import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'deep_work_screen.dart';
import 'insight_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int? _deepWorkTaskId; // State to pass to DeepWorkScreen

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToDeepWork(int taskId) {
    setState(() {
      _deepWorkTaskId = taskId;
      _selectedIndex = 1; // Switch to Deep Work tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardScreen(onStartFocus: _navigateToDeepWork),
          DeepWorkScreen(initialTaskId: _deepWorkTaskId),
          InsightScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Command',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lens_blur),
            label: 'Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights_rounded),
            label: 'Intelligence',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white24,
        backgroundColor: const Color(0xFF020617), // Match deep bg
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
