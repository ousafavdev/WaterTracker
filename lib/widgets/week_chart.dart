import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../format.dart';

class WeekChart extends StatelessWidget {
  const WeekChart({super.key, required this.counts, required this.todayIndex});

  final List<int> counts;
  final int todayIndex;

  @override
  Widget build(BuildContext context) {
    final maxCount = counts.fold<int>(
      0,
      (max, count) => count > max ? count : max,
    );
    return SizedBox(
      height: 196,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var index = 0; index < counts.length; index++)
            Expanded(
              child: _Bar(
                label: weekdayShort[index],
                count: counts[index],
                maxCount: maxCount,
                highlight: index == todayIndex,
              ),
            ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.label,
    required this.count,
    required this.maxCount,
    required this.highlight,
  });

  final String label;
  final int count;
  final int maxCount;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final fraction = maxCount == 0 ? 0.0 : count / maxCount;
    final target = fraction == 0 ? 0.05 : fraction;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: highlight ? AppTheme.ocean : AppTheme.inkSoft,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: target),
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    heightFactor: value.clamp(0.04, 1),
                    widthFactor: 0.62,
                    child: child,
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: highlight
                        ? AppTheme.buttonGradient
                        : AppTheme.barGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: highlight ? AppTheme.ocean : AppTheme.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
