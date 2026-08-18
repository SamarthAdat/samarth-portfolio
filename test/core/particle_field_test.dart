import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:samarth_portfolio/core/widgets/particle_background/particle.dart';
import 'package:samarth_portfolio/core/widgets/particle_background/particle_field.dart';
import 'package:samarth_portfolio/core/widgets/particle_background/particle_style.dart';

const ParticleStyle _style = ParticleStyle.constellation();

ParticleField _fieldOfSize(Size size) {
  return ParticleField(style: _style, random: math.Random(7))..resize(size);
}

void main() {
  group('population', () {
    test('scales with the canvas area, within the configured bounds', () {
      final int small = _fieldOfSize(const Size(900, 600)).particleCount;
      final int large = _fieldOfSize(const Size(1600, 900)).particleCount;

      expect(large, greaterThan(small));
      expect(
        large,
        inInclusiveRange(_style.minParticles, _style.maxParticles),
      );

      // A huge canvas is capped, a tiny one is floored.
      expect(
        _fieldOfSize(const Size(4000, 3000)).particleCount,
        _style.maxParticles,
      );
      expect(
        _fieldOfSize(const Size(200, 200)).particleCount,
        _style.minParticles,
      );
    });

    test('spawns every particle inside the canvas', () {
      final ParticleField field = _fieldOfSize(const Size(1200, 800));

      for (final Particle particle in field.particles) {
        expect(particle.x, inInclusiveRange(0, 1200));
        expect(particle.y, inInclusiveRange(0, 800));
      }
    });

    test('keeps relative positions when the canvas is resized', () {
      final ParticleField field = _fieldOfSize(const Size(1000, 500));
      final Particle first = field.particles.first;
      final double relativeX = first.x / 1000;

      field.resize(const Size(2000, 1000));

      expect(field.particles.first.x / 2000, closeTo(relativeX, 1e-9));
    });
  });

  group('motion', () {
    test('moves particles along their velocity', () {
      final ParticleField field = _fieldOfSize(const Size(1200, 800));
      final Particle particle = field.particles.first;
      final double startX = particle.x;
      final double startY = particle.y;

      field.update(dt: 1 / 60);

      expect(
        Offset(particle.x, particle.y),
        isNot(Offset(startX, startY)),
      );
    });

    test('wraps particles back inside after a long run', () {
      final ParticleField field = _fieldOfSize(const Size(600, 400));

      for (int i = 0; i < 600; i++) {
        field.update(dt: 1 / 30);
      }

      final double margin = _style.maxRadius;
      for (final Particle particle in field.particles) {
        expect(particle.x, inInclusiveRange(-margin, 600 + margin));
        expect(particle.y, inInclusiveRange(-margin, 400 + margin));
      }
    });

    test('pushes particles away from the pointer and lets them settle', () {
      final ParticleField field = _fieldOfSize(const Size(800, 600));
      final Particle particle = field.particles.first;
      final Offset pointer = Offset(particle.x - 10, particle.y);

      final double distanceBefore = (Offset(particle.x, particle.y) - pointer)
          .distance;
      field.update(dt: 1 / 60, pointer: pointer);
      final double distanceAfter = (Offset(particle.x, particle.y) - pointer)
          .distance;

      expect(distanceAfter, greaterThan(distanceBefore));

      // With the pointer gone, the velocity eases back toward the drift.
      for (int i = 0; i < 240; i++) {
        field.update(dt: 1 / 60);
      }
      expect(particle.speed, lessThanOrEqualTo(_style.maxSpeed + 1));
    });

    test('never exceeds the speed limit, even under sustained pushing', () {
      final ParticleField field = _fieldOfSize(const Size(800, 600));

      for (int i = 0; i < 300; i++) {
        field.update(dt: 1 / 60, pointer: const Offset(400, 300));
      }

      for (final Particle particle in field.particles) {
        expect(particle.speed, lessThanOrEqualTo(_style.speedLimit + 1e-6));
      }
    });
  });

  group('links', () {
    test('connects each close pair exactly once, with no self-links', () {
      final ParticleField field = _fieldOfSize(const Size(900, 700));
      final Set<String> seen = <String>{};
      int linkCount = 0;

      field.forEachLink((Particle a, Particle b, double strength) {
        expect(identical(a, b), isFalse);

        final int first = field.particles.indexOf(a);
        final int second = field.particles.indexOf(b);
        final String key = first < second ? '$first:$second' : '$second:$first';

        expect(seen.add(key), isTrue, reason: 'duplicate link $key');
        linkCount++;
      });

      expect(linkCount, greaterThan(0));
    });

    test('agrees with a brute-force pass over every pair', () {
      final ParticleField field = _fieldOfSize(const Size(900, 700));
      final List<Particle> particles = field.particles;

      int expected = 0;
      for (int i = 0; i < particles.length; i++) {
        for (int j = i + 1; j < particles.length; j++) {
          final double dx = particles[i].x - particles[j].x;
          final double dy = particles[i].y - particles[j].y;
          if (math.sqrt(dx * dx + dy * dy) <= _style.linkDistance) expected++;
        }
      }

      int actual = 0;
      field.forEachLink((_, _, _) => actual++);

      expect(actual, expected);
    });

    test('strength falls from 1 at the pointer to 0 at the link distance', () {
      final ParticleField field = _fieldOfSize(const Size(900, 700));
      final Particle particle = field.particles.first;

      double? strength;
      field.forEachPointerLink(Offset(particle.x, particle.y), (
        Particle hit,
        double value,
      ) {
        if (identical(hit, particle)) strength = value;
      });

      expect(strength, closeTo(1, 1e-9));

      final List<double> strengths = <double>[];
      field.forEachPointerLink(
        Offset(particle.x + _style.pointerLinkDistance * 0.5, particle.y),
        (Particle hit, double value) {
          if (identical(hit, particle)) strengths.add(value);
        },
      );

      expect(strengths.single, closeTo(0.5, 1e-9));
    });
  });
}
