import 'models/bottle_entry.dart';

const weekdayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

const weekdayLong = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const monthShort = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

DateTime startOfWeek(DateTime value) {
  final day = dateOnly(value);
  return day.subtract(Duration(days: day.weekday - 1));
}

int todayIndexFor(DateTime weekStart) {
  final today = dateOnly(DateTime.now());
  final start = dateOnly(weekStart);
  final diff = today.difference(start).inDays;
  if (diff < 0 || diff > 6) {
    return -1;
  }
  return diff;
}

String formatLongDate(DateTime value) {
  final year = value.year == DateTime.now().year ? '' : ', ${value.year}';
  return '${weekdayLong[value.weekday - 1]}, ${monthShort[value.month - 1]} ${value.day}$year';
}

String formatShortDate(DateTime value) {
  final year = value.year == DateTime.now().year ? '' : ', ${value.year}';
  return '${monthShort[value.month - 1]} ${value.day}$year';
}

String formatTime(DateTime value) {
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  final minute = value.minute.toString().padLeft(2, '0');
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}

String formatAverage(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
}

String busiestDayLabel(List<int> counts) {
  final maxCount = counts.fold<int>(
    0,
    (max, count) => count > max ? count : max,
  );
  if (maxCount == 0) {
    return '—';
  }
  return '${weekdayShort[counts.indexOf(maxCount)]} · $maxCount';
}

String buildTodayCopy(DateTime day, List<BottleEntry> entries) {
  final total = entries.fold<int>(0, (sum, entry) => sum + entry.count);
  final buffer = StringBuffer()
    ..writeln('💧 DEWater Tracker')
    ..writeln('📅 ${formatLongDate(day)}')
    ..writeln('🫙 Bottles used: $total');
  if (entries.isEmpty) {
    buffer.writeln('No bottles logged.');
  } else {
    buffer.writeln();
    for (final entry in entries) {
      final note = entry.note.trim().isEmpty ? '' : ' — ${entry.note.trim()}';
      buffer.writeln(
        '${entry.emoji} ${entry.name} ×${entry.count} · ${formatTime(entry.at)}$note',
      );
    }
  }
  return buffer.toString().trimRight();
}

String buildHistoryCopy(List<DayGroup> days) {
  final total = days.fold<int>(0, (sum, day) => sum + day.total);
  final buffer = StringBuffer()
    ..writeln('💧 DEWater Tracker')
    ..writeln('📅 History')
    ..writeln('🫙 Bottles used: $total');
  if (days.isEmpty) {
    buffer.writeln('No bottles logged.');
  } else {
    for (final day in days) {
      buffer
        ..writeln()
        ..writeln('${formatLongDate(day.day)} · ${day.total}');
      for (final entry in day.entries) {
        buffer.writeln(
          '${entry.emoji} ${entry.name} ×${entry.count} · ${formatTime(entry.at)}',
        );
      }
    }
  }
  return buffer.toString().trimRight();
}

String buildWeekCopy(DateTime weekStart, List<int> counts) {
  final total = counts.fold<int>(0, (sum, count) => sum + count);
  final buffer = StringBuffer()
    ..writeln('💧 DEWater Tracker')
    ..writeln('📊 Week of ${formatShortDate(weekStart)}')
    ..writeln('🫙 Bottles used: $total')
    ..writeln('📈 Daily average: ${formatAverage(total / 7)}')
    ..writeln('🏆 Busiest day: ${busiestDayLabel(counts)}')
    ..writeln();
  for (var index = 0; index < 7; index++) {
    buffer.writeln('${weekdayShort[index]} · ${counts[index]}');
  }
  return buffer.toString().trimRight();
}
