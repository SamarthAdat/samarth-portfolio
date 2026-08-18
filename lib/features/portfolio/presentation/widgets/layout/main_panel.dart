import 'package:flutter/material.dart';

import '../../controllers/contact_form_controller.dart';
import '../../controllers/portfolio_controller.dart';
import '../../state/portfolio_tab.dart';
import '../about/about_section.dart';
import '../common/glass_card.dart';
import '../common/section_title.dart';
import '../contact/contact_section.dart';
import '../navigation/portfolio_tab_bar.dart';
import '../projects/projects_section.dart';
import '../resume/resume_download_button.dart';
import '../resume/resume_section.dart';

/// The right-hand panel: tab bar, section heading, and the active section.
class MainPanel extends StatelessWidget {
  final PortfolioController controller;
  final ContactFormController contactFormController;
  final bool isDesktop;
  final VoidCallback onDownloadResume;

  const MainPanel({
    super.key,
    required this.controller,
    required this.contactFormController,
    required this.isDesktop,
    required this.onDownloadResume,
  });

  @override
  Widget build(BuildContext context) {
    final double availableHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).top -
        MediaQuery.paddingOf(context).bottom -
        (isDesktop ? 56 : 32);

    const EdgeInsets bodyPadding = EdgeInsets.fromLTRB(30, 30, 30, 36);

    return SizedBox(
      height: isDesktop ? availableHeight : null,
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Desktop: fill the SizedBox. Mobile: shrink-wrap so the outer
          // scroll view can size the panel to its content.
          mainAxisSize: isDesktop ? MainAxisSize.max : MainAxisSize.min,
          children: <Widget>[
            PortfolioTabBar(
              selectedTab: controller.selectedTab,
              onTabSelected: controller.selectTab,
            ),
            // Desktop scrolls inside the panel; mobile defers to the page's
            // scroll view. No section uses Expanded, so both work.
            if (isDesktop)
              Expanded(
                child: SingleChildScrollView(
                  padding: bodyPadding,
                  child: _buildAnimatedBody(context),
                ),
              )
            else
              Padding(padding: bodyPadding, child: _buildAnimatedBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBody(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 360),
      reverseDuration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.03, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<PortfolioTab>(controller.selectedTab),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(context),
            const SizedBox(height: 26),
            _buildSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final PortfolioTab tab = controller.selectedTab;
    final SectionTitle title = SectionTitle(
      title: tab.title,
      subtitle: tab.subtitle,
    );

    if (tab != PortfolioTab.resume) return title;

    // The Resume tab pairs its heading with the download button, stacking them
    // when the panel is too narrow for both on one line.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget button = ResumeDownloadButton(onPressed: onDownloadResume);

        if (constraints.maxWidth < 670) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[title, const SizedBox(height: 14), button],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: title),
            const SizedBox(width: 14),
            button,
          ],
        );
      },
    );
  }

  Widget _buildSection() {
    return switch (controller.selectedTab) {
      PortfolioTab.about => AboutSection(state: controller.about),
      PortfolioTab.resume => ResumeSection(state: controller.resume),
      PortfolioTab.portfolio => ProjectsSection(state: controller.projects),
      PortfolioTab.contact => ContactSection(
        controller: contactFormController,
      ),
    };
  }
}
