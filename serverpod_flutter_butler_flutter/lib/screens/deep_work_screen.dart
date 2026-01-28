import 'package:flutter/material.dart';
import '../../main.dart'; // Access to global client

class DeepWorkScreen extends StatefulWidget {
  const DeepWorkScreen({super.key});

  @override
  State<DeepWorkScreen> createState() => _DeepWorkScreenState();
}

class _DeepWorkScreenState extends State<DeepWorkScreen> {
  bool _isSessionActive = false;
  String? _statusMessage;

  Future<void> _startSession() async {
    setState(() {
      _statusMessage = 'Starting session...';
    });

    try {
      // Start a 1 minute session for demo purposes
      await client.focus.startSession(1);
      setState(() {
        _isSessionActive = true;
        _statusMessage = 'Deep Work Mode ON\nSlack Status: "Deep Work until..."\nNotifications: Muted';
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
        _statusMessage = 'Session Ended Early.\nSlack Status: Restored';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Work Butler'),
        backgroundColor: _isSessionActive ? Colors.deepPurple : null,
        foregroundColor: _isSessionActive ? Colors.white : null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isSessionActive ? Colors.nightlight_round : Colors.sunny,
              size: 100,
              color: _isSessionActive ? Colors.deepPurple : Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(
              _statusMessage ?? 'Ready to Focus?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 40),
            if (_isSessionActive)
              ElevatedButton(
                onPressed: _stopSession,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('Stop Session'),
              )
            else
              ElevatedButton.icon(
                onPressed: _startSession,
                icon: const Icon(Icons.flash_on),
                label: const Text('Start Deep Work (1 min demo)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
