import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';
import '../widgets/chrome.dart';
import '../widgets/entry_sheet.dart';
import 'history_page.dart';
import 'statistics_page.dart';
import 'today_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _pages = [
    TodayPage(key: ValueKey('today')),
    HistoryPage(key: ValueKey('history')),
    StatisticsPage(key: ValueKey('stats')),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 320),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final offset = Tween<Offset>(
                              begin: const Offset(0, 0.04),
                              end: Offset.zero,
                            ).animate(animation);
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: offset,
                                child: child,
                              ),
                            );
                          },
                          child: _pages[_index],
                        ),
                      ),
                      if (_index < 2)
                        Positioned(
                          right: 20,
                          bottom: 4,
                          child: AddBottleButton(
                            onPressed: () => showBottleEditor(context),
                          ),
                        ),
                    ],
                  ),
                ),
                _AppNavBar(
                  index: _index,
                  onChanged: (value) => setState(() => _index = value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppNavBar extends StatelessWidget {
  const _AppNavBar({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  static const _items = [
    ('💧', 'Today', 'nav-today'),
    ('📅', 'History', 'nav-history'),
    ('📊', 'Statistics', 'nav-stats'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              for (var item = 0; item < _items.length; item++)
                Expanded(
                  child: _NavItem(
                    emoji: _items[item].$1,
                    label: _items[item].$2,
                    itemKey: Key(_items[item].$3),
                    selected: index == item,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onChanged(item);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.emoji,
    required this.label,
    required this.itemKey,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final Key itemKey;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: itemKey,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: selected ? AppTheme.buttonGradient : null,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : AppTheme.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
