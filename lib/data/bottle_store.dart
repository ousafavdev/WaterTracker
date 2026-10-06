import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../format.dart';
import '../models/bottle_entry.dart';

class BottleStore extends ChangeNotifier {
  BottleStore({List<BottleEntry>? entries, SharedPreferences? preferences})
    : _entries = List<BottleEntry>.of(entries ?? const []),
      _preferences = preferences;

  static const storageKey = 'dewater_bottles_v1';

  final List<BottleEntry> _entries;
  final SharedPreferences? _preferences;
  int _nextId = 0;

  static Future<BottleStore> open() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(storageKey);
    return BottleStore(entries: _decode(raw), preferences: preferences);
  }

  static List<BottleEntry> _decode(String? raw) {
    if (raw == null || raw.isEmpty) {
      return [];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return [];
      }
      return [
        for (final item in decoded)
          if (item is Map)
            BottleEntry.fromJson(Map<String, dynamic>.from(item)),
      ];
    } catch (_) {
      return [];
    }
  }

  String createId() => '${DateTime.now().microsecondsSinceEpoch}-${_nextId++}';

  int get total => _entries.fold(0, (sum, entry) => sum + entry.count);

  List<BottleEntry> entriesOn(DateTime day) {
    final target = dateOnly(day);
    final list = _entries
        .where((entry) => dateOnly(entry.at) == target)
        .toList();
    list.sort((a, b) => b.at.compareTo(a.at));
    return list;
  }

  int totalOn(DateTime day) {
    return entriesOn(day).fold(0, (sum, entry) => sum + entry.count);
  }

  List<DayGroup> get days {
    final grouped = <DateTime, List<BottleEntry>>{};
    for (final entry in _entries) {
      grouped.putIfAbsent(dateOnly(entry.at), () => []).add(entry);
    }
    final groups = grouped.entries.map((entry) {
      final items = List<BottleEntry>.of(entry.value)
        ..sort((a, b) => b.at.compareTo(a.at));
      return DayGroup(day: entry.key, entries: items);
    }).toList()..sort((a, b) => b.day.compareTo(a.day));
    return groups;
  }

  List<int> countsForWeek(DateTime weekStart) {
    final start = dateOnly(weekStart);
    return List<int>.generate(
      7,
      (index) => totalOn(start.add(Duration(days: index))),
    );
  }

  Future<void> add(BottleEntry entry) async {
    _entries.add(entry);
    notifyListeners();
    await _persist();
  }

  Future<void> update(BottleEntry entry) async {
    final index = _entries.indexWhere((item) => item.id == entry.id);
    if (index == -1) {
      return;
    }
    _entries[index] = entry;
    notifyListeners();
    await _persist();
  }

  Future<void> remove(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final preferences = _preferences;
    if (preferences == null) {
      return;
    }
    await preferences.setString(
      storageKey,
      jsonEncode(_entries.map((entry) => entry.toJson()).toList()),
    );
  }
}

class BottleScope extends InheritedNotifier<BottleStore> {
  const BottleScope({
    super.key,
    required BottleStore store,
    required super.child,
  }) : super(notifier: store);

  static BottleStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<BottleScope>();
    assert(scope != null, 'BottleScope is missing above this widget');
    return scope!.notifier!;
  }
}
