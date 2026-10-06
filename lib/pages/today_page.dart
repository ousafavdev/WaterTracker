import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../data/bottle_store.dart';
import '../format.dart';
import '../widgets/actions.dart';
import '../widgets/bottle_card.dart';
import '../widgets/chrome.dart';
import '../widgets/entry_sheet.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = BottleScope.of(context);
    final now = DateTime.now();
    final entries = store.entriesOn(now);
    final total = store.totalOn(now);
    final copyText = buildTodayCopy(now, entries);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 88),
      children: [
        PageHeader(
          emoji: '💧',
          title: 'Today',
          subtitle: formatLongDate(now),
          onShare: () => shareSummary(context, copyText),
        ),
        WhiteCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BOTTLES TODAY',
                      style: TextStyle(
                        color: AppTheme.ocean,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        fontSize: 12,
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: total.toDouble()),
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Text(
                          value.round().toString(),
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        );
                      },
                    ),
                    Text(
                      total == 1 ? 'bottle used' : 'bottles used',
                      style: const TextStyle(
                        color: AppTheme.inkSoft,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Text('💧', style: TextStyle(fontSize: 52)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        GradientButton(
          key: const Key('copy-button'),
          label: '📋  Copy',
          onPressed: () => copySummary(context, copyText),
        ),
        const SectionLabel('Today’s bottles'),
        if (entries.isEmpty)
          const EmptyCard(
            emoji: '🫙',
            title: 'Nothing logged yet',
            message:
                'Add a bottle you used. This tracker counts bottles, not health.',
          )
        else
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BottleCard(
                entry: entry,
                onEdit: () => showBottleEditor(context, existing: entry),
                onDelete: () => deleteEntry(context, entry.id),
              ),
            ),
      ],
    );
  }
}
