import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';

class WhiteCard extends StatelessWidget {
  const WhiteCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color = Colors.white,
    this.shadow = true,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: shadow ? AppTheme.cardShadow : null,
      ),
      child: child,
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onShare,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$emoji  $title',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.ink,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.inkSoft,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppTheme.cardShadow,
            ),
            child: IconButton(
              tooltip: 'Share',
              onPressed: onShare,
              icon: const Icon(Icons.ios_share_rounded, color: AppTheme.ocean),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          shadows: [Shadow(color: Color(0x6608334A), blurRadius: 8)],
        ),
      ),
    );
  }
}

class EmptyCard extends StatelessWidget {
  const EmptyCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.message,
  });

  final String emoji;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 42)),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.inkSoft,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onPressed();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: AppTheme.buttonGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class AddBottleButton extends StatefulWidget {
  const AddBottleButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<AddBottleButton> createState() => _AddBottleButtonState();
}

class _AddBottleButtonState extends State<AddBottleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('add-bottle'),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onPressed();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            gradient: AppTheme.buttonGradient,
            borderRadius: BorderRadius.circular(999),
            boxShadow: AppTheme.cardShadow,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('➕', style: TextStyle(fontSize: 16)),
              SizedBox(width: 6),
              Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAppMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 108),
      ),
    );
}
