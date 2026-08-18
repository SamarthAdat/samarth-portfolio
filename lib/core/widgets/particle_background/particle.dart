import 'dart:math' as math;

/// One drifting dot.
///
/// Position and velocity are plain doubles rather than `Offset`s: they change
/// every frame, and this avoids allocating throw-away objects 60 times a
/// second for every particle on screen.
class Particle {
  double x;
  double y;
  double vx;
  double vy;

  /// The velocity the particle settles back to after the pointer pushes it.
  final double baseVx;
  final double baseVy;

  final double radius;

  /// Per-particle opacity multiplier, which keeps the field from looking flat.
  final double alphaScale;

  Particle({
    required this.x,
    required this.y,
    required this.baseVx,
    required this.baseVy,
    required this.radius,
    required this.alphaScale,
  }) : vx = baseVx,
       vy = baseVy;

  double get speed => math.sqrt(vx * vx + vy * vy);
}
