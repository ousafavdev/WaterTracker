import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../data/bottle_store.dart';
import '../format.dart';
import '../models/bottle_entry.dart';
import '../widgets/actions.dart';
import '../widgets/bottle_card.dart';
import '../widgets/chrome.dart';
import '../widgets/entry_sheet.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = BottleScope.of(context);
    final days = store.days;
    final copyText = buildHistoryCopy(days);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 88),
      children: [
        PageHeader(
          emoji: '📅',
          title: 'History',
          subtitle: 'Every bottle you logged',
          onShare: () => shareSummary(context, copyText),
        ),
        WhiteCard(
          child: Row(
            children: [
              const Text('🌊', style: TextStyle(fontSize: 36)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${store.total}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    const Text(
                      'bottles in the log',
                      style: TextStyle(
                        color: AppTheme.inkSoft,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        GradientButton(
          key: const Key('copy-button'),
          label: '📋  Copy',
          onPressed: () => copySummary(context, copyText),
        ),
        const SectionLabel('By day'),
        if (days.isEmpty)
          const EmptyCard(
            emoji: '📭',
            title: 'No history yet',
            message:
                'Days you log will gather here. Add, edit, or delete anytime.',
          )
        else
          for (final day in days) _DayCard(group: day),
      ],
    );
  }
}

class _DayCard extends StatefulWidget {
  const _DayCard({required this.group});

  final DayGroup group;

  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: WhiteCard(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => setState(() => _open = !_open),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  const Text('📅', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatLongDate(group.day),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          '${group.total} ${group.total == 1 ? 'bottle' : 'bottles'}',
                          style: const TextStyle(
                            color: AppTheme.inkSoft,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more_rounded),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: _open
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: [
                          for (final entry in group.entries)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: BottleCard(
                                entry: entry,
                                nested: true,
                                onEdit: () =>
                                    showBottleEditor(context, existing: entry),
                                onDelete: () => deleteEntry(context, entry.id),
                              ),
                            ),
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
