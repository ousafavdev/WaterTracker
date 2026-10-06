import 'package:dewaterk4n/data/bottle_store.dart';
import 'package:dewaterk4n/format.dart';
import 'package:dewaterk4n/models/bottle_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('copy text stays empty until bottles are logged', () {
    final day = DateTime(2026, 10, 1, 9);
    final text = buildTodayCopy(day, const []);
    expect(text, contains('Bottles used: 0'));
    expect(text, contains('No bottles logged.'));
  });

  test('store starts empty and supports add, edit, and delete', () async {
    final store = BottleStore();
    expect(store.total, 0);
    expect(store.days, isEmpty);

    final entry = BottleEntry(
      id: store.createId(),
      at: DateTime(2026, 10, 1, 9, 15),
      emoji: '💧',
      name: 'Office',
      count: 2,
      note: 'Desk',
    );
    await store.add(entry);
    expect(store.total, 2);
    expect(store.entriesOn(entry.at).single.name, 'Office');

    await store.update(entry.copyWith(name: 'Gym', count: 1));
    expect(store.total, 1);
    expect(store.entriesOn(entry.at).single.name, 'Gym');

    await store.remove(entry.id);
    expect(store.total, 0);
    expect(store.days, isEmpty);
  });

  test('weekly counts line up with the Monday start', () async {
    final store = BottleStore();
    final monday = DateTime(2026, 9, 28, 8);
    await store.add(
      BottleEntry(
        id: 'a',
        at: monday,
        emoji: '🥤',
        name: 'Gym',
        count: 3,
        note: '',
      ),
    );
    final counts = store.countsForWeek(startOfWeek(monday));
    expect(counts, [3, 0, 0, 0, 0, 0, 0]);
    expect(busiestDayLabel(counts), 'Mon · 3');
  });
}
