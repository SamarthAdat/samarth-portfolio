import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// A wrapping row of skill chips.
class SkillChipWrap extends StatelessWidget {
  final List<String> items;

  const SkillChipWrap({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items
          .map((String item) => HoverSkillChip(label: item))
          .toList(growable: false),
    );
  }
}

/// A chip that fills with the accent colour and drifts slightly toward the
/// pointer while hovered.
class HoverSkillChip extends StatefulWidget {
  final String label;

  const HoverSkillChip({super.key, required this.label});

  @override
  State<HoverSkillChip> createState() => _HoverSkillChipState();
}

class _HoverSkillChipState extends State<HoverSkillChip> {
  static const double _maxDrift = 6;

  bool _isHovered = false;
  Offset _drift = Offset.zero;

  void _handleHover(PointerHoverEvent event) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Size size = box.size;
    final Offset local = event.localPosition;

    setState(() {
      _drift = Offset(
        ((local.dx - size.width / 2) / size.width) * _maxDrift,
        ((local.dy - size.height / 2) / size.height) * _maxDrift,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _drift = Offset.zero;
      }),
      onHover: _handleHover,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translateByDouble(_drift.dx, _drift.dy, 0.0, 1.0),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.accent : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppColors.accent : AppColors.border,
          ),
          boxShadow: _isHovered
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x22FFDB70),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: _isHovered ? Colors.black : AppColors.muted,
            fontWeight: FontWeight.w700,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
