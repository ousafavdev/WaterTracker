const bottleEmojis = ['💧', '🍼', '🥤', '🫙', '🥛', '🍶', '🧊', '💦'];

class BottleEntry {
  const BottleEntry({
    required this.id,
    required this.at,
    required this.emoji,
    required this.name,
    required this.count,
    required this.note,
  });

  final String id;
  final DateTime at;
  final String emoji;
  final String name;
  final int count;
  final String note;

  BottleEntry copyWith({
    DateTime? at,
    String? emoji,
    String? name,
    int? count,
    String? note,
  }) {
    return BottleEntry(
      id: id,
      at: at ?? this.at,
      emoji: emoji ?? this.emoji,
      name: name ?? this.name,
      count: count ?? this.count,
      note: note ?? this.note,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'at': at.toIso8601String(),
      'emoji': emoji,
      'name': name,
      'count': count,
      'note': note,
    };
  }

  factory BottleEntry.fromJson(Map<String, dynamic> json) {
    final rawCount = (json['count'] as num?)?.toInt() ?? 1;
    return BottleEntry(
      id: json['id'] as String? ?? '',
      at: DateTime.tryParse(json['at'] as String? ?? '') ?? DateTime.now(),
      emoji: json['emoji'] as String? ?? '💧',
      name: json['name'] as String? ?? 'Bottle',
      count: rawCount.clamp(1, 99).toInt(),
      note: json['note'] as String? ?? '',
    );
  }
}

class DayGroup {
  const DayGroup({required this.day, required this.entries});

  final DateTime day;
  final List<BottleEntry> entries;

  int get total => entries.fold(0, (sum, entry) => sum + entry.count);
}
