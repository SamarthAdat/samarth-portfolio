import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/project.dart';
import '../../mappers/portfolio_icons.dart';
import '../common/hover_glow_card.dart';
import 'stack_chip.dart';

/// A case-study card in the project grid.
class ProjectShowcaseCard extends StatelessWidget {
  /// Highlights shown on the compact card.
  static const int _visibleHighlights = 2;

  final Project project;
  final Color accent;

  const ProjectShowcaseCard({
    super.key,
    required this.project,
    this.accent = AppColors.accent,
  });

  @override
  Widget build(BuildContext context) {
    return HoverGlowCard(
      accent: accent,
      style: const HoverGlowStyle.projectCard(),
      builder: (BuildContext context, bool isHovered) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context, isHovered),
          const SizedBox(height: 13),
          Text(
            project.role,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            project.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            project.summary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.55,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          _buildOutcome(context),
          const SizedBox(height: 12),
          ...project.highlights
              .take(_visibleHighlights)
              .map((String highlight) => _buildHighlight(context, highlight)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.stack
                .map((String item) => StackChip(label: item, tone: accent))
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isHovered) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isHovered ? 0.22 : 0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accent.withValues(alpha: isHovered ? 0.58 : 0.30),
            ),
          ),
          child: Icon(
            PortfolioIcons.forProject(project.category),
            color: accent,
            size: 22,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.85)),
          ),
          child: Text(
            project.duration,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.muted,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutcome(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.32)),
      ),
      child: Text(
        project.outcome,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.text, height: 1.45),
      ),
    );
  }

  Widget _buildHighlight(BuildContext context, String highlight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.arrow_forward_ios_rounded, size: 12, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              highlight,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
