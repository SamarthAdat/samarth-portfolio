import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'particle.dart';
import 'particle_field.dart';
import 'particle_style.dart';

/// Draws the field: links first, then the dots on top.
///
/// The pointer arrives as a listenable that is read at paint time, so moving
/// the mouse repaints this layer without rebuilding any widget.
class ParticleFieldPainter extends CustomPainter {
  final ParticleField field;
  final ParticleStyle style;
  final ValueListenable<Offset?> pointer;

  ParticleFieldPainter({
    required this.field,
    required this.style,
    required this.pointer,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..strokeWidth = style.lineWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    field.forEachLink((Particle a, Particle b, double strength) {
      linePaint.color = style.linkColor.withValues(
        alpha: style.linkOpacity * strength,
      );
      canvas.drawLine(Offset(a.x, a.y), Offset(b.x, b.y), linePaint);
    });

    final Offset? cursor = pointer.value;
    if (cursor != null) {
      linePaint.strokeWidth = style.lineWidth * 1.15;

      field.forEachPointerLink(cursor, (Particle particle, double strength) {
        linePaint.color = style.linkColor.withValues(
          alpha: style.pointerLinkOpacity * strength,
        );
        canvas.drawLine(cursor, Offset(particle.x, particle.y), linePaint);
      });
    }

    final Paint dotPaint = Paint()..isAntiAlias = true;

    for (final Particle particle in field.particles) {
      dotPaint.color = style.dotColor.withValues(
        alpha: style.dotOpacity * particle.alphaScale,
      );
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.radius,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticleFieldPainter oldDelegate) {
    // Frame-to-frame repainting is driven by the `repaint` listenable; this
    // only needs to catch a swap of what is being painted.
    return oldDelegate.field != field ||
        oldDelegate.style != style ||
        oldDelegate.pointer != pointer;
  }
}
