import 'package:flutter/material.dart';

import '../../domain/entities/contact_channel.dart';
import '../../domain/entities/metric.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/value_proposition.dart';

/// Sections of the resume that get their own heading icon.
enum ResumeSectionKind { experience, education, toolkit, coursework, awards }

/// Translates domain concepts into icons.
///
/// This mapping is the reason the domain can stay free of Flutter: entities
/// carry a meaning (`MetricKind.audience`), and the choice of glyph is made
/// here, in the presentation layer.
class PortfolioIcons {
  const PortfolioIcons._();

  static IconData forChannel(ContactChannelType type) => switch (type) {
    ContactChannelType.email => Icons.email_outlined,
    ContactChannelType.phone => Icons.phone_outlined,
    ContactChannelType.location => Icons.location_on_outlined,
    ContactChannelType.github => Icons.code,
    ContactChannelType.linkedIn => Icons.link,
  };

  static IconData forMetric(MetricKind kind) => switch (kind) {
    MetricKind.audience => Icons.groups_2_outlined,
    MetricKind.performance => Icons.rocket_launch_outlined,
    MetricKind.leadership => Icons.handshake_outlined,
    MetricKind.award => Icons.emoji_events_outlined,
  };

  static IconData forExpertise(ExpertiseArea area) => switch (area) {
    ExpertiseArea.mobile => Icons.phone_android,
    ExpertiseArea.backend => Icons.cloud_queue,
    ExpertiseArea.cloud => Icons.dns_outlined,
    ExpertiseArea.analytics => Icons.analytics_outlined,
  };

  static IconData forProject(ProjectCategory category) => switch (category) {
    ProjectCategory.agriTech => Icons.agriculture_outlined,
    ProjectCategory.machineLearning => Icons.auto_awesome_outlined,
    ProjectCategory.healthcare => Icons.local_hospital_outlined,
    ProjectCategory.conversationalAi => Icons.smart_toy_outlined,
    ProjectCategory.services => Icons.water_drop_outlined,
  };

  static IconData forResumeSection(ResumeSectionKind section) => switch (section) {
    ResumeSectionKind.experience => Icons.work_outline,
    ResumeSectionKind.education => Icons.school_outlined,
    ResumeSectionKind.toolkit => Icons.verified_outlined,
    ResumeSectionKind.coursework => Icons.menu_book_outlined,
    ResumeSectionKind.awards => Icons.emoji_events_outlined,
  };
}
