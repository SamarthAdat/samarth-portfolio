import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Tuning for [HoverGlowCard]. The two named constructors reproduce the two
/// looks the portfolio uses.
class HoverGlowStyle {
  final Color midColor;
  final double gradientMidStop;
  final double topTint;
  final double liftDistance;
  final double pointerGlowRadius;
  final double pointerGlowOpacity;
  final double borderBaseOpacity;
  final double borderHoverGain;
  final double shadowBaseOpacity;
  final double shadowHoverGain;
  final double shadowSpread;
  final bool showClickCursor;

  const HoverGlowStyle({
    required this.midColor,
    required this.gradientMidStop,
    required this.topTint,
    required this.liftDistance,
    required this.pointerGlowRadius,
    required this.pointerGlowOpacity,
    required this.borderBaseOpacity,
    required this.borderHoverGain,
    required this.shadowBaseOpacity,
    required this.shadowHoverGain,
    required this.shadowSpread,
    required this.showClickCursor,
  });

  /// The "How I Create Value" cards.
  const HoverGlowStyle.valueCard()
    : midColor = AppColors.glowCardMidAlt,
      gradientMidStop = 0.25,
      topTint = 0.1,
      liftDistance = 3,
      pointerGlowRadius = 0.9,
      pointerGlowOpacity = 0.18,
      borderBaseOpacity = 0.24,
      borderHoverGain = 0.32,
      shadowBaseOpacity = 0.06,
      shadowHoverGain = 0.14,
      shadowSpread = 2,
      showClickCursor = false;

  /// The project case-study cards.
  const HoverGlowStyle.projectCard()
    : midColor = AppColors.glowCardMid,
      gradientMidStop = 0.3,
      topTint = 0.12,
      liftDistance = 4,
      pointerGlowRadius = 0.95,
      pointerGlowOpacity = 0.20,
      borderBaseOpacity = 0.28,
      borderHoverGain = 0.34,
      shadowBaseOpacity = 0.06,
      shadowHoverGain = 0.16,
      shadowSpread = 1.5,
      showClickCursor = true;
}

/// A card that lifts, brightens its border, and follows the pointer with a
/// radial glow while hovered.
///
/// Extracted from the two near-identical implementations that previously lived
/// inside the value cards and the project cards.
class HoverGlowCard extends StatefulWidget {
  /// Builds the card's contents. [isHovered] lets the content follow the same
  /// hover state as the card frame, e.g. to brighten an icon.
  final Widget Function(BuildContext context, bool isHovered) builder;

  final Color accent;
  final HoverGlowStyle style;
  final EdgeInsetsGeometry padding;

  const HoverGlowCard({
    super.key,
    required this.builder,
    required this.style,
    this.accent = AppColors.accent,
    this.padding = const EdgeInsets.all(22),
  });

  @override
  State<HoverGlowCard> createState() => _HoverGlowCardState();
}

class _HoverGlowCardState extends State<HoverGlowCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final Animation<double> _glow = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  Offset _pointer = Offset.zero;
  Size _cardSize = Size.zero;
  bool _hovered = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent event) {
    setState(() => _hovered = true);
    _controller.forward();
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _hovered = false;
      _pointer = Offset.zero;
      _cardSize = Size.zero;
    });
    _controller.reverse();
  }

  void _onHover(PointerEvent event) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    setState(() {
      _pointer = box.globalToLocal(event.position);
      _cardSize = box.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    final HoverGlowStyle style = widget.style;

    return MouseRegion(
      cursor: style.showClickCursor
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: _onHover,
      child: AnimatedBuilder(
        animation: _glow,
        builder: (BuildContext context, _) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..translateByDouble(
                0.0,
                _hovered ? -style.liftDistance : 0.0,
                0.0,
                1.0,
              ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  widget.accent.withValues(alpha: style.topTint),
                  style.midColor.withValues(alpha: 0.95),
                  AppColors.glowCardBase.withValues(alpha: 0.98),
                ],
                stops: <double>[0.0, style.gradientMidStop, 1.0],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.accent.withValues(
                  alpha: style.borderBaseOpacity +
                      style.borderHoverGain * _glow.value,
                ),
                width: 1.2,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: widget.accent.withValues(
                    alpha: style.shadowBaseOpacity +
                        style.shadowHoverGain * _glow.value,
                  ),
                  blurRadius: 24 + 16 * _glow.value,
                  spreadRadius: style.shadowSpread,
                  offset: const Offset(0, 8),
                ),
                const BoxShadow(
                  color: AppColors.softShadow,
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: <Widget>[
                  if (_hovered && _cardSize != Size.zero)
                    Positioned.fill(child: _buildPointerGlow(style)),
                  Padding(
                    padding: widget.padding,
                    child: widget.builder(context, _hovered),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPointerGlow(HoverGlowStyle style) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(
              (_pointer.dx / _cardSize.width) * 2 - 1,
              (_pointer.dy / _cardSize.height) * 2 - 1,
            ),
            radius: style.pointerGlowRadius,
            colors: <Color>[
              widget.accent.withValues(
                alpha: style.pointerGlowOpacity * _glow.value,
              ),
              widget.accent.withValues(alpha: 0.0),
            ],
          ),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
