import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../data/bottle_store.dart';
import '../format.dart';
import '../widgets/actions.dart';
import '../widgets/chrome.dart';
import '../widgets/week_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int _weekOffset = 0;

  @override
  Widget build(BuildContext context) {
    final store = BottleScope.of(context);
    final weekStart = startOfWeek(
      DateTime.now(),
    ).add(Duration(days: 7 * _weekOffset));
    final counts = store.countsForWeek(weekStart);
    final total = counts.fold<int>(0, (sum, count) => sum + count);
    final activeDays = counts.where((count) => count > 0).length;
    final copyText = buildWeekCopy(weekStart, counts);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        PageHeader(
          emoji: '📊',
          title: 'Statistics',
          subtitle: 'Daily graph and weekly summary',
          onShare: () => shareSummary(context, copyText),
        ),
        WhiteCard(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              IconButton(
                key: const Key('week-prev'),
                tooltip: 'Previous week',
                onPressed: () => setState(() => _weekOffset -= 1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      _weekOffset == 0 ? 'This week' : 'Week',
                      style: const TextStyle(
                        color: AppTheme.ocean,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      formatShortDate(weekStart),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('week-next'),
                tooltip: 'Next week',
                onPressed: () => setState(() => _weekOffset += 1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        WhiteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📅 Daily graph',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                total == 0
                    ? 'No bottles this week yet.'
                    : '$total ${total == 1 ? 'bottle' : 'bottles'} across the week',
                style: const TextStyle(
                  color: AppTheme.inkSoft,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              WeekChart(counts: counts, todayIndex: todayIndexFor(weekStart)),
            ],
          ),
        ),
        const SectionLabel('Weekly summary'),
        WhiteCard(
          child: Column(
            children: [
              _StatRow(
                emoji: '🫙',
                label: 'Bottles this week',
                value: '$total',
              ),
              _StatRow(
                emoji: '📈',
                label: 'Daily average',
                value: formatAverage(total / 7),
              ),
              _StatRow(
                emoji: '🏆',
                label: 'Busiest day',
                value: busiestDayLabel(counts),
              ),
              _StatRow(
                emoji: '📆',
                label: 'Days with bottles',
                value: '$activeDays',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        WhiteCard(
          child: _StatRow(
            emoji: '🌊',
            label: 'All-time bottles',
            value: '${store.total}',
          ),
        ),
        const SizedBox(height: 14),
        GradientButton(
          key: const Key('copy-button'),
          label: '📋  Copy',
          onPressed: () => copySummary(context, copyText),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.emoji,
    required this.label,
    required this.value,
  });

  final String emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
