import 'package:shared_preferences/shared_preferences.dart';

class CounterStorage {
  static const _counterKey = 'counter';
  static const _historyKey = 'history';

  int _counter = 0;
  List<String> _history = [];

  int get counter => _counter;

  CounterStorage() {
    _loadCounter(); // Call this to initialize counter
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt(_counterKey) ?? 0;
    _history = prefs.getStringList(_historyKey) ?? [];
  }

  Future<void> increment() async {
    _counter++;
    await _saveCounter();
  }

  Future<void> decrement() async {
    _counter--;
    await _saveCounter();
  }

  Future<void> reset() async {
    _counter = 0;
    await _saveCounter();
  }

  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, _counter);
    _history.add('$_counter at ${DateTime.now().toLocal()}');
    await prefs.setStringList(_historyKey, _history);
  }

  Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_historyKey) ?? [];
  }

  Future<void> addToHistory(String value) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    history.add(value);
    await prefs.setStringList(_historyKey, history);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  Future<void> removeHistoryItem(String item) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    history.remove(item);
    await prefs.setStringList(_historyKey, history);
  }
}
