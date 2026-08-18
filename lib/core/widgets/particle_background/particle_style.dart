import 'dart:ui';

import '../../theme/app_colors.dart';

/// Tuning for the constellation background.
///
/// Every number the effect depends on lives here, so the look can be adjusted
/// without touching the simulation or the painter.
class ParticleStyle {
  /// Area, in logical pixels squared, allotted to one particle. Larger values
  /// mean a sparser field.
  final double areaPerParticle;

  final int minParticles;
  final int maxParticles;

  final double minRadius;
  final double maxRadius;

  /// Drift speed range, in logical pixels per second.
  final double minSpeed;
  final double maxSpeed;

  /// Ceiling applied after the pointer pushes a particle.
  final double speedLimit;

  /// Particles closer than this get connected by a line.
  final double linkDistance;

  final Color dotColor;
  final Color linkColor;
  final double dotOpacity;

  /// Opacity of a link at zero distance; it fades to nothing at [linkDistance].
  final double linkOpacity;

  final double lineWidth;

  /// Draw lines from the pointer to nearby particles.
  final bool pointerLinksEnabled;
  final double pointerLinkDistance;
  final double pointerLinkOpacity;

  /// Radius within which the pointer nudges particles away.
  final double pointerRepelRadius;

  /// Acceleration applied at the centre of the repel radius, in px/s².
  final double pointerRepelStrength;

  /// How quickly a pushed particle returns to its drift velocity, per second.
  final double velocityRestore;

  const ParticleStyle({
    required this.areaPerParticle,
    required this.minParticles,
    required this.maxParticles,
    required this.minRadius,
    required this.maxRadius,
    required this.minSpeed,
    required this.maxSpeed,
    required this.speedLimit,
    required this.linkDistance,
    required this.dotColor,
    required this.linkColor,
    required this.dotOpacity,
    required this.linkOpacity,
    required this.lineWidth,
    required this.pointerLinksEnabled,
    required this.pointerLinkDistance,
    required this.pointerLinkOpacity,
    required this.pointerRepelRadius,
    required this.pointerRepelStrength,
    required this.velocityRestore,
  });

  /// The default look: a slow gold mesh on the dark background, scaled to read
  /// clearly from across the room rather than as a faint texture.
  const ParticleStyle.constellation()
    : areaPerParticle = 11000,
      minParticles = 32,
      maxParticles = 150,
      minRadius = 1.6,
      maxRadius = 3.8,
      minSpeed = 7,
      maxSpeed = 26,
      speedLimit = 110,
      linkDistance = 185,
      dotColor = AppColors.accent,
      linkColor = AppColors.accent,
      dotOpacity = 0.82,
      linkOpacity = 0.42,
      lineWidth = 1.35,
      pointerLinksEnabled = true,
      pointerLinkDistance = 240,
      pointerLinkOpacity = 0.62,
      pointerRepelRadius = 150,
      pointerRepelStrength = 260,
      velocityRestore = 2.4;

  /// How many particles a canvas of [size] should hold.
  int particleCountFor(Size size) {
    if (size.isEmpty) return 0;

    final int count = (size.width * size.height / areaPerParticle).round();
    return count.clamp(minParticles, maxParticles);
  }
}
