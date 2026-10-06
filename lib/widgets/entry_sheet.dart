import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';
import '../data/bottle_store.dart';
import '../format.dart';
import '../models/bottle_entry.dart';
import 'actions.dart';
import 'chrome.dart';

Future<void> showBottleEditor(
  BuildContext context, {
  BottleEntry? existing,
}) async {
  final message = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) => EntrySheet(existing: existing),
  );
  if (message == null || !context.mounted) {
    return;
  }
  showAppMessage(context, message);
}

class EntrySheet extends StatefulWidget {
  const EntrySheet({super.key, this.existing});

  final BottleEntry? existing;

  @override
  State<EntrySheet> createState() => _EntrySheetState();
}

class _EntrySheetState extends State<EntrySheet> {
  late final TextEditingController _name;
  late final TextEditingController _note;
  late DateTime _at;
  late String _emoji;
  late int _count;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _name = TextEditingController(text: existing?.name ?? '');
    _note = TextEditingController(text: existing?.note ?? '');
    _at = existing?.at ?? DateTime.now();
    _emoji = existing?.emoji ?? bottleEmojis.first;
    _count = existing?.count ?? 1;
  }

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _at,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _at = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _at.hour,
        _at.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_at),
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _at = DateTime(_at.year, _at.month, _at.day, picked.hour, picked.minute);
    });
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      showAppMessage(context, 'Give the bottle a name');
      return;
    }
    final store = BottleScope.of(context);
    final note = _note.text.trim();
    final existing = widget.existing;
    if (existing == null) {
      await store.add(
        BottleEntry(
          id: store.createId(),
          at: _at,
          emoji: _emoji,
          name: name,
          count: _count,
          note: note,
        ),
      );
    } else {
      await store.update(
        existing.copyWith(
          at: _at,
          emoji: _emoji,
          name: name,
          count: _count,
          note: note,
        ),
      );
    }
    if (!mounted) {
      return;
    }
    Navigator.pop(
      context,
      existing == null ? 'Added $_emoji $name' : '✏️ Updated',
    );
  }

  @override
  Widget build(BuildContext context) {
    final existing = widget.existing;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              existing == null ? '➕ Add bottle' : '✏️ Edit bottle',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Name it, pick an emoji, and set how many you used.',
              style: TextStyle(
                color: AppTheme.inkSoft,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final emoji in bottleEmojis)
                  GestureDetector(
                    onTap: () => setState(() => _emoji = emoji),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: _emoji == emoji
                            ? AppTheme.buttonGradient
                            : null,
                        color: _emoji == emoji ? null : AppTheme.mist,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('bottle-name'),
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [LengthLimitingTextInputFormatter(40)],
              decoration: const InputDecoration(
                labelText: 'Bottle name',
                hintText: 'Office bottle',
                filled: true,
                fillColor: AppTheme.mist,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [LengthLimitingTextInputFormatter(80)],
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'Left at the desk',
                filled: true,
                fillColor: AppTheme.mist,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StepperButton(
                  icon: Icons.remove_rounded,
                  onPressed: _count > 1
                      ? () => setState(() => _count -= 1)
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '×$_count',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.add_rounded,
                  onPressed: _count < 99
                      ? () => setState(() => _count += 1)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  _count == 1 ? 'bottle' : 'bottles',
                  style: const TextStyle(
                    color: AppTheme.inkSoft,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _PickerChip(
                    emoji: '📅',
                    label: formatShortDate(_at),
                    onPressed: _pickDate,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PickerChip(
                    emoji: '⏰',
                    label: formatTime(_at),
                    onPressed: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GradientButton(
              key: const Key('save-bottle'),
              label: existing == null ? 'Save bottle' : 'Save changes',
              onPressed: _save,
            ),
            if (existing != null) ...[
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () async {
                    final confirmed = await askToDelete(context);
                    if (!confirmed || !context.mounted) {
                      return;
                    }
                    await BottleScope.of(context).remove(existing.id);
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pop(context, '🗑️ Deleted');
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Color(0xFFC62828),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(onPressed: onPressed, icon: Icon(icon));
  }
}

class _PickerChip extends StatelessWidget {
  const _PickerChip({
    required this.emoji,
    required this.label,
    required this.onPressed,
  });

  final String emoji;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.mist,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Text(
            '$emoji  $label',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
