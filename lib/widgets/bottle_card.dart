import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../format.dart';
import '../models/bottle_entry.dart';
import 'chrome.dart';

class BottleCard extends StatelessWidget {
  const BottleCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
    this.nested = false,
  });

  final BottleEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool nested;

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      color: nested ? AppTheme.mist : Colors.white,
      shadow: !nested,
      padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: nested ? Colors.white : AppTheme.mist,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(entry.emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '×${entry.count}  ·  ${formatTime(entry.at)}',
                    style: const TextStyle(
                      color: AppTheme.inkSoft,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (entry.note.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      entry.note.trim(),
                      style: const TextStyle(color: AppTheme.ink, height: 1.3),
                    ),
                  ],
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Delete',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
    );
  }
}
