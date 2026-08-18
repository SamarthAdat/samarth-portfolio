import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'particle_field.dart';
import 'particle_field_painter.dart';
import 'particle_style.dart';

/// Paints a drifting constellation behind [child].
///
/// The pointer is tracked by a [MouseRegion] that wraps the whole subtree, so
/// hovering anywhere — including over the content on top — feeds the effect
/// while leaving taps, scrolls, and hover states of the content untouched.
class ParticleBackground extends StatefulWidget {
  final Widget child;
  final ParticleStyle style;

  const ParticleBackground({
    super.key,
    required this.child,
    this.style = const ParticleStyle.constellation(),
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  /// Guards against a huge first step, or a jump after the tab was inactive.
  static const double _maxFrameSeconds = 1 / 30;

  late final ParticleField _field = ParticleField(style: widget.style);

  /// Bumped once per frame to drive repaints without rebuilding widgets.
  final ValueNotifier<int> _frame = ValueNotifier<int>(0);
  final ValueNotifier<Offset?> _pointer = ValueNotifier<Offset?>(null);

  late final Listenable _repaint = Listenable.merge(<Listenable>[
    _frame,
    _pointer,
  ]);

  Ticker? _ticker;
  Duration _lastElapsed = Duration.zero;
  bool _animating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Honour the platform's reduced-motion setting: the field is still drawn,
    // it simply holds still.
    _setAnimating(!MediaQuery.disableAnimationsOf(context));
  }

  void _setAnimating(bool shouldAnimate) {
    if (shouldAnimate == _animating) return;
    _animating = shouldAnimate;

    if (shouldAnimate) {
      _lastElapsed = Duration.zero;
      _ticker ??= createTicker(_onTick);
      _ticker!.start();
    } else {
      _ticker?.stop();
    }
  }

  void _onTick(Duration elapsed) {
    final double seconds =
        (elapsed - _lastElapsed).inMicroseconds / Duration.microsecondsPerSecond;
    _lastElapsed = elapsed;

    _field.update(
      dt: seconds.clamp(0, _maxFrameSeconds),
      pointer: _pointer.value,
    );
    _frame.value++;
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _frame.dispose();
    _pointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: false,
      onHover: (PointerHoverEvent event) =>
          _pointer.value = event.localPosition,
      onExit: (_) => _pointer.value = null,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          RepaintBoundary(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                _field.resize(constraints.biggest);

                return CustomPaint(
                  isComplex: true,
                  willChange: true,
                  painter: ParticleFieldPainter(
                    field: _field,
                    style: widget.style,
                    pointer: _pointer,
                    repaint: _repaint,
                  ),
                );
              },
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
