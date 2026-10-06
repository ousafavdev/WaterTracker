import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../data/bottle_store.dart';
import 'chrome.dart';

Future<void> copySummary(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  HapticFeedback.selectionClick();
  if (!context.mounted) {
    return;
  }
  showAppMessage(context, '📋 Copied');
}

Future<void> shareSummary(BuildContext context, String text) async {
  final box = context.findRenderObject() as RenderBox?;
  Rect? origin;
  if (box != null && box.hasSize) {
    origin = box.localToGlobal(Offset.zero) & box.size;
  }
  try {
    await SharePlus.instance.share(
      ShareParams(text: text, sharePositionOrigin: origin),
    );
  } catch (_) {
    if (!context.mounted) {
      return;
    }
    showAppMessage(context, 'Could not open the share sheet');
  }
}

Future<bool> askToDelete(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete this bottle?'),
        content: const Text('🗑️ This removes it from your log.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            key: const Key('confirm-delete'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFC62828)),
            ),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}

Future<void> deleteEntry(BuildContext context, String id) async {
  final confirmed = await askToDelete(context);
  if (!confirmed || !context.mounted) {
    return;
  }
  await BottleScope.of(context).remove(id);
  if (!context.mounted) {
    return;
  }
  showAppMessage(context, '🗑️ Deleted');
}
