import 'package:shared_preferences/shared_preferences.dart';

class CounterStorage {
  int _counter = 0;
  List<String> _history = [];

  int get counter => _counter;

  Future<void> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('counter') ?? 0;
    _history = prefs.getStringList('history') ?? [];
  }

  void increment() => _counter++;
  void decrement() => _counter--;
  void reset() => _counter = 0;

  Future<void> saveToHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList('history') ?? [];
    _history.add("Count: $_counter at ${DateTime.now()}");
    await prefs.setStringList('history', _history);
    await prefs.setInt('counter', _counter);
  }

  Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('history') ?? [];
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
    _history.clear();
  }

  Future<void> removeHistoryItem(String item) async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList('history') ?? [];
    _history.remove(item);
    await prefs.setStringList('history', _history);
  }
}
