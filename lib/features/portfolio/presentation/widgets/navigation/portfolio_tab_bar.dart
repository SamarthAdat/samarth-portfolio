import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../state/portfolio_tab.dart';

/// The horizontal tab strip at the top of the main panel.
class PortfolioTabBar extends StatelessWidget {
  final PortfolioTab selectedTab;
  final ValueChanged<PortfolioTab> onTabSelected;

  const PortfolioTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  static const Map<PortfolioTab, IconData> _icons = <PortfolioTab, IconData>{
    PortfolioTab.about: Icons.person,
    PortfolioTab.resume: Icons.article_outlined,
    PortfolioTab.portfolio: Icons.workspaces_outline,
    PortfolioTab.contact: Icons.mail_outline,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.navigationGradient,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.95)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: PortfolioTab.values
              .map(
                (PortfolioTab tab) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _TabButton(
                    tab: tab,
                    icon: _icons[tab]!,
                    isSelected: tab == selectedTab,
                    onPressed: () => onTabSelected(tab),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final PortfolioTab tab;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const _TabButton({
    required this.tab,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? AppColors.accent : AppColors.muted,
        backgroundColor: isSelected
            ? AppColors.accent.withValues(alpha: 0.12)
            : AppColors.card.withValues(alpha: 0.22),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected
                ? AppColors.accent.withValues(alpha: 0.32)
                : AppColors.border.withValues(alpha: 0.75),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16.5),
          const SizedBox(width: 8),
          Text(
            tab.label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
          if (isSelected) ...<Widget>[
            const SizedBox(width: 8),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
