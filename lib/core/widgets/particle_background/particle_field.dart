import 'dart:math' as math;
import 'dart:ui';

import 'particle.dart';
import 'particle_style.dart';

/// Called for each connected pair. [strength] runs from 1 at zero distance to
/// 0 at the link distance.
typedef LinkVisitor = void Function(Particle a, Particle b, double strength);

/// Called for each particle within reach of the pointer.
typedef PointerLinkVisitor =
    void Function(Particle particle, double strength);

/// The constellation simulation.
///
/// Pure Dart with no Flutter widget or canvas involvement, so its behaviour —
/// population, wrapping, and which particles link — can be unit tested.
class ParticleField {
  final ParticleStyle style;
  final math.Random _random;

  final List<Particle> _particles = <Particle>[];
  Size _size = Size.zero;

  /// Uniform grid over the canvas, one cell per link distance. Rebuilt each
  /// frame and reused between frames so linking stays allocation-free.
  final List<List<Particle>> _cells = <List<Particle>>[];
  int _columns = 0;
  int _rows = 0;

  ParticleField({
    this.style = const ParticleStyle.constellation(),
    math.Random? random,
  }) : _random = random ?? math.Random();

  List<Particle> get particles => List<Particle>.unmodifiable(_particles);

  int get particleCount => _particles.length;

  Size get size => _size;

  /// Fits the field to [size], keeping existing particles in their relative
  /// positions and adding or trimming to match the new target population.
  void resize(Size size) {
    if (size == _size || size.isEmpty) return;

    final Size previous = _size;
    _size = size;

    if (previous.isEmpty) {
      for (final Particle particle in _particles) {
        particle.x = _random.nextDouble() * size.width;
        particle.y = _random.nextDouble() * size.height;
      }
    } else {
      final double scaleX = size.width / previous.width;
      final double scaleY = size.height / previous.height;
      for (final Particle particle in _particles) {
        particle.x *= scaleX;
        particle.y *= scaleY;
      }
    }

    final int target = style.particleCountFor(size);
    while (_particles.length > target) {
      _particles.removeLast();
    }
    while (_particles.length < target) {
      _particles.add(_spawn());
    }

    _buildCells();
  }

  /// Advances the simulation by [dt] seconds. [pointer] is the cursor position
  /// in canvas coordinates, or `null` when the pointer is away.
  void update({required double dt, Offset? pointer}) {
    if (_size.isEmpty || dt <= 0) return;

    for (final Particle particle in _particles) {
      if (pointer != null) _repel(particle, pointer, dt);

      // Ease back toward the drift velocity so a push fades out instead of
      // leaving the particle permanently faster.
      particle.vx += (particle.baseVx - particle.vx) * style.velocityRestore * dt;
      particle.vy += (particle.baseVy - particle.vy) * style.velocityRestore * dt;

      final double speed = particle.speed;
      if (speed > style.speedLimit) {
        final double scale = style.speedLimit / speed;
        particle.vx *= scale;
        particle.vy *= scale;
      }

      particle.x += particle.vx * dt;
      particle.y += particle.vy * dt;

      _wrap(particle);
    }

    _populateCells();
  }

  /// Visits every pair of particles close enough to be connected.
  void forEachLink(LinkVisitor visit) {
    if (_particles.isEmpty || _cells.isEmpty) return;

    final double maxDistance = style.linkDistance;
    final double maxDistanceSquared = maxDistance * maxDistance;

    for (int column = 0; column < _columns; column++) {
      for (int row = 0; row < _rows; row++) {
        final List<Particle> cell = _cells[row * _columns + column];
        if (cell.isEmpty) continue;

        // Compare within this cell and against the four neighbours ahead of
        // it, so each pair is considered exactly once.
        _linkWithin(cell, maxDistanceSquared, maxDistance, visit);
        _linkBetween(cell, column + 1, row, maxDistanceSquared, maxDistance, visit);
        _linkBetween(cell, column - 1, row + 1, maxDistanceSquared, maxDistance, visit);
        _linkBetween(cell, column, row + 1, maxDistanceSquared, maxDistance, visit);
        _linkBetween(cell, column + 1, row + 1, maxDistanceSquared, maxDistance, visit);
      }
    }
  }

  /// Visits every particle within the pointer's link distance.
  void forEachPointerLink(Offset pointer, PointerLinkVisitor visit) {
    if (!style.pointerLinksEnabled) return;

    final double maxDistance = style.pointerLinkDistance;
    final double maxDistanceSquared = maxDistance * maxDistance;

    for (final Particle particle in _particles) {
      final double dx = particle.x - pointer.dx;
      final double dy = particle.y - pointer.dy;
      final double distanceSquared = dx * dx + dy * dy;
      if (distanceSquared > maxDistanceSquared) continue;

      visit(particle, 1 - math.sqrt(distanceSquared) / maxDistance);
    }
  }

  Particle _spawn() {
    final double angle = _random.nextDouble() * math.pi * 2;
    final double speed =
        style.minSpeed + _random.nextDouble() * (style.maxSpeed - style.minSpeed);

    return Particle(
      x: _random.nextDouble() * _size.width,
      y: _random.nextDouble() * _size.height,
      baseVx: math.cos(angle) * speed,
      baseVy: math.sin(angle) * speed,
      radius:
          style.minRadius +
          _random.nextDouble() * (style.maxRadius - style.minRadius),
      alphaScale: 0.55 + _random.nextDouble() * 0.45,
    );
  }

  void _repel(Particle particle, Offset pointer, double dt) {
    final double dx = particle.x - pointer.dx;
    final double dy = particle.y - pointer.dy;
    final double distanceSquared = dx * dx + dy * dy;
    final double radius = style.pointerRepelRadius;

    if (distanceSquared > radius * radius || distanceSquared == 0) return;

    final double distance = math.sqrt(distanceSquared);
    final double push = style.pointerRepelStrength * (1 - distance / radius) * dt;

    particle.vx += (dx / distance) * push;
    particle.vy += (dy / distance) * push;
  }

  /// Particles leaving one edge re-enter from the opposite one, which keeps
  /// the density even instead of letting them pile up against a wall.
  void _wrap(Particle particle) {
    final double margin = style.maxRadius;

    if (particle.x < -margin) {
      particle.x = _size.width + margin;
    } else if (particle.x > _size.width + margin) {
      particle.x = -margin;
    }

    if (particle.y < -margin) {
      particle.y = _size.height + margin;
    } else if (particle.y > _size.height + margin) {
      particle.y = -margin;
    }
  }

  void _buildCells() {
    _columns = math.max(1, (_size.width / style.linkDistance).ceil());
    _rows = math.max(1, (_size.height / style.linkDistance).ceil());

    _cells
      ..clear()
      ..addAll(
        List<List<Particle>>.generate(
          _columns * _rows,
          (_) => <Particle>[],
          growable: false,
        ),
      );

    _populateCells();
  }

  void _populateCells() {
    if (_cells.isEmpty) return;

    for (final List<Particle> cell in _cells) {
      cell.clear();
    }

    for (final Particle particle in _particles) {
      final int column = (particle.x / style.linkDistance).floor().clamp(
        0,
        _columns - 1,
      );
      final int row = (particle.y / style.linkDistance).floor().clamp(
        0,
        _rows - 1,
      );
      _cells[row * _columns + column].add(particle);
    }
  }

  void _linkWithin(
    List<Particle> cell,
    double maxDistanceSquared,
    double maxDistance,
    LinkVisitor visit,
  ) {
    for (int i = 0; i < cell.length; i++) {
      for (int j = i + 1; j < cell.length; j++) {
        _tryLink(cell[i], cell[j], maxDistanceSquared, maxDistance, visit);
      }
    }
  }

  void _linkBetween(
    List<Particle> cell,
    int column,
    int row,
    double maxDistanceSquared,
    double maxDistance,
    LinkVisitor visit,
  ) {
    if (column < 0 || column >= _columns || row < 0 || row >= _rows) return;

    final List<Particle> other = _cells[row * _columns + column];
    if (other.isEmpty) return;

    for (final Particle a in cell) {
      for (final Particle b in other) {
        _tryLink(a, b, maxDistanceSquared, maxDistance, visit);
      }
    }
  }

  void _tryLink(
    Particle a,
    Particle b,
    double maxDistanceSquared,
    double maxDistance,
    LinkVisitor visit,
  ) {
    final double dx = a.x - b.x;
    final double dy = a.y - b.y;
    final double distanceSquared = dx * dx + dy * dy;
    if (distanceSquared > maxDistanceSquared) return;

    visit(a, b, 1 - math.sqrt(distanceSquared) / maxDistance);
  }
}
