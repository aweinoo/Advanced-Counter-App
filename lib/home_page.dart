import 'package:flutter/material.dart';
import 'counter_storage.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CounterStorage _counterStorage = CounterStorage();
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() {
    setState(() {
      _counter = _counterStorage.counter;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counterStorage.increment();
      _counter = _counterStorage.counter;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counterStorage.decrement();
      _counter = _counterStorage.counter;
    });
  }

  void _resetCounter() {
    setState(() {
      _counterStorage.reset();
      _counter = _counterStorage.counter;
    });
  }

  void _openHistoryPage() {
    Navigator.pushNamed(context, '/history');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFFFFDE7),
      appBar: AppBar(
        title: const Text('Counter App'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.history, size: 30),
          onPressed: _openHistoryPage, // <-- You will define this function
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Switch(
              value: context.watch<ThemeProvider>().isDarkMode,
              onChanged: (value) {
                context.read<ThemeProvider>().toggleTheme();
              },
            ),
          ),
          // IconButton(icon: const Icon(Icons.refresh), onPressed: _resetCounter),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Counter Value:', style: TextStyle(fontSize: 30)),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 65, // 👈 Set desired width
                  height: 65, // 👈 Set desired height
                  child: FloatingActionButton(
                    heroTag: "increment",
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: const Icon(Icons.add, size: 30),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "decrement",
                    onPressed: _decrementCounter,
                    tooltip: 'Decrement',
                    child: const Icon(Icons.remove, size: 30),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "reset",
                    onPressed: _resetCounter,
                    tooltip: 'Reset',
                    child: const Icon(Icons.refresh, size: 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
