import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/value_proposition.dart';
import '../../mappers/portfolio_icons.dart';
import '../common/hover_glow_card.dart';

/// One "How I Create Value" card.
class ValuePropositionCard extends StatelessWidget {
  final ValueProposition proposition;

  const ValuePropositionCard({super.key, required this.proposition});

  @override
  Widget build(BuildContext context) {
    return HoverGlowCard(
      style: const HoverGlowStyle.valueCard(),
      builder: (BuildContext context, bool isHovered) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.36),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              PortfolioIcons.forExpertise(proposition.area),
              color: AppColors.accent,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  proposition.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  proposition.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.5,
                    height: 1.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
