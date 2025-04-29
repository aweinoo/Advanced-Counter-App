import 'package:flutter/material.dart';
import 'counter_storage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final CounterStorage _counterStorage = CounterStorage();
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final List<String> storedHistory = await _counterStorage.getHistory();
    setState(() {
      _history = storedHistory.reversed.toList();
    });
  }

  Future<void> _clearHistory() async {
    await _counterStorage.clearHistory();
    if (mounted) {
      setState(() {
        _history.clear();
      });

      // Show snackbar confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('History cleared successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _removeEntry(String entry) async {
    await _counterStorage.removeHistoryItem(entry);
    if (mounted) {
      setState(() {
        _history.remove(entry);
      });

      // Optional: individual deletion confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entry removed.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(Icons.delete_forever, color: Colors.red),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Clear History'),
                        content: const Text(
                          'Are you sure you want to delete all history?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _clearHistory();
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Confirm',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
              },
            ),
        ],
      ),
      body:
          _history.isEmpty
              ? const Center(
                child: Text(
                  'No history recorded yet!',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final item = _history[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(item),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _removeEntry(item),
                    ),
                  );
                },
              ),
    );
  }
}
