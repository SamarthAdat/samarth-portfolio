import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_links.dart';
import '../../core/theme/app_theme.dart';
import '../../data/portfolio_data.dart';

enum PortfolioTab { about, resume, portfolio, contact }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PortfolioTab selectedTab = PortfolioTab.about;

  Future<void> _openUrl(String value) async {
    if (value == '#') return;
    final Uri parsed = Uri.parse(value);
    final Uri uri = parsed.hasScheme ? parsed : Uri.base.resolveUri(parsed);
    final LaunchMode mode = parsed.hasScheme
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault;
    await launchUrl(uri, mode: mode);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final bool isDesktop = width >= 980;
    final double desktopCardHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).top -
        MediaQuery.paddingOf(context).bottom -
        56;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1220),
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 28 : 16),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 310,
                          height: desktopCardHeight,
                          child: _ProfileSidebar(onOpenUrl: _openUrl),
                        ),
                        const SizedBox(width: 28),
                        Expanded(
                          child: _MainPanel(
                            selectedTab: selectedTab,
                            onTabChanged: (tab) =>
                                setState(() => selectedTab = tab),
                            onOpenUrl: _openUrl,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _ProfileSidebar(onOpenUrl: _openUrl),
                                const SizedBox(height: 18),
                                _MainPanel(
                                  selectedTab: selectedTab,
                                  onTabChanged: (tab) =>
                                      setState(() => selectedTab = tab),
                                  onOpenUrl: _openUrl,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PROFILE SIDEBAR
// ─────────────────────────────────────────────────────────────

class _ProfileSidebar extends StatelessWidget {
  final Future<void> Function(String value) onOpenUrl;

  const _ProfileSidebar({required this.onOpenUrl});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(26),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            const _ProfilePhoto(),
            const SizedBox(height: 22),
            Text(
              PortfolioData.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.cardLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Text(
                PortfolioData.role,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppTheme.muted),
              ),
            ),
            const SizedBox(height: 22),
            const Divider(color: AppTheme.border),
            const SizedBox(height: 8),
            _ContactTile(
              icon: Icons.email_outlined,
              label: 'EMAIL',
              value: PortfolioData.email,
              onTap: () => onOpenUrl(AppLinks.email),
            ),
            _ContactTile(
              icon: Icons.phone_outlined,
              label: 'PHONE',
              value: PortfolioData.phone,
              onTap: () => onOpenUrl(AppLinks.phone),
            ),
            _ContactTile(
              icon: Icons.location_on_outlined,
              label: 'LOCATION',
              value: PortfolioData.location,
              onTap: null,
            ),
            _ContactTile(
              icon: Icons.code,
              label: 'GITHUB',
              value: 'https://github.com/samarthadat',
              onTap: () => onOpenUrl(AppLinks.github),
            ),
            _ContactTile(
              icon: Icons.link,
              label: 'LINKEDIN',
              value: 'https://www.linkedin.com/in/samarthadat/',
              onTap: () => onOpenUrl(AppLinks.linkedIn),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.accent, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0x33FFDB70), blurRadius: 28, spreadRadius: 4),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/profile.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppTheme.cardLight,
              alignment: Alignment.center,
              child: const Text(
                'SA',
                style: TextStyle(
                  color: AppTheme.accent,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CONTACT TILE
// ─────────────────────────────────────────────────────────────

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.cardLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Icon(icon, color: AppTheme.accent, size: 20),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.softMuted,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.text,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MAIN PANEL
// ─────────────────────────────────────────────────────────────

class _MainPanel extends StatelessWidget {
  final PortfolioTab selectedTab;
  final ValueChanged<PortfolioTab> onTabChanged;
  final Future<void> Function(String value) onOpenUrl;

  const _MainPanel({
    required this.selectedTab,
    required this.onTabChanged,
    required this.onOpenUrl,
  });

  String get _title {
    switch (selectedTab) {
      case PortfolioTab.about:
        return 'About Me';
      case PortfolioTab.resume:
        return 'Resume';
      case PortfolioTab.portfolio:
        return 'Portfolio';
      case PortfolioTab.contact:
        return 'Contact';
    }
  }

  Widget _buildContent() {
    switch (selectedTab) {
      case PortfolioTab.about:
        return const _AboutContent();
      case PortfolioTab.resume:
        return const _ResumeContent();
      case PortfolioTab.portfolio:
        return const _PortfolioContent();
      case PortfolioTab.contact:
        return const _ContactContent();
    }
  }

  Widget _buildHeader(BuildContext context) {
    final bool showResumeButton = selectedTab == PortfolioTab.resume;

    if (!showResumeButton) return _SectionTitle(_title);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 670;
        final Widget button = _ResumeDownloadButton(onOpenUrl: onOpenUrl);

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(_title),
              const SizedBox(height: 14),
              button,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: _SectionTitle('Resume')),
            const SizedBox(width: 14),
            button,
          ],
        );
      },
    );
  }

  Widget _buildAnimatedTabBody(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 360),
      reverseDuration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        final slide =
            Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<PortfolioTab>(selectedTab),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 26),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.sizeOf(context).width >= 980;
    final double availableHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).top -
        MediaQuery.paddingOf(context).bottom -
        (isDesktop ? 56 : 32);

    return SizedBox(
      height: isDesktop ? availableHeight : null,
      child: _GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // On desktop Column fills the SizedBox (max). On mobile it shrink-wraps.
          mainAxisSize: isDesktop ? MainAxisSize.max : MainAxisSize.min,
          children: [
            _TopNavigation(
              selectedTab: selectedTab,
              onTabChanged: onTabChanged,
            ),
            // Desktop: Expanded + SingleChildScrollView fills remaining height.
            // Mobile: plain Padding, outer scroll view handles overflow.
            // _AboutContent (and all others) never use Expanded internally,
            // so they work correctly in both contexts.
            isDesktop
                ? Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 36),
                      child: _buildAnimatedTabBody(context),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 36),
                    child: _buildAnimatedTabBody(context),
                  ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TOP NAVIGATION TABS
// ─────────────────────────────────────────────────────────────

class _TopTabItem {
  final PortfolioTab tab;
  final String label;
  final IconData icon;

  const _TopTabItem({
    required this.tab,
    required this.label,
    required this.icon,
  });
}

class _TopNavigation extends StatelessWidget {
  final PortfolioTab selectedTab;
  final ValueChanged<PortfolioTab> onTabChanged;

  const _TopNavigation({required this.selectedTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    const tabs = [
      _TopTabItem(tab: PortfolioTab.about, label: 'About', icon: Icons.person),
      _TopTabItem(
        tab: PortfolioTab.resume,
        label: 'Resume',
        icon: Icons.article_outlined,
      ),
      _TopTabItem(
        tab: PortfolioTab.portfolio,
        label: 'Portfolio',
        icon: Icons.workspaces_outline,
      ),
      _TopTabItem(
        tab: PortfolioTab.contact,
        label: 'Contact',
        icon: Icons.mail_outline,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2C), Color(0xFF222224)],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          bottom: BorderSide(color: AppTheme.border.withOpacity(0.95)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((item) {
            final bool selected = item.tab == selectedTab;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: () => onTabChanged(item.tab),
                style: TextButton.styleFrom(
                  foregroundColor: selected ? AppTheme.accent : AppTheme.muted,
                  backgroundColor: selected
                      ? AppTheme.accent.withOpacity(0.12)
                      : AppTheme.card.withOpacity(0.22),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: selected
                          ? AppTheme.accent.withOpacity(0.32)
                          : AppTheme.border.withOpacity(0.75),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, size: 16.5),
                    const SizedBox(width: 8),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                    if (selected) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ABOUT CONTENT
// ── IMPORTANT: No Expanded anywhere in this widget tree.
//    Grid uses shrinkWrap=true + fixed mainAxisExtent.
//    The SingleChildScrollView in _MainPanel handles scrolling.
// ─────────────────────────────────────────────────────────────

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  static const List<_AboutMetric> _metrics = [
    _AboutMetric(
      icon: Icons.groups_2_outlined,
      value: '10k+',
      label: 'Farmers using production app',
    ),
    _AboutMetric(
      icon: Icons.rocket_launch_outlined,
      value: '60%',
      label: 'Faster post loading performance',
    ),
    _AboutMetric(
      icon: Icons.handshake_outlined,
      value: '8',
      label: 'Engineers led on core product',
    ),
    _AboutMetric(
      icon: Icons.emoji_events_outlined,
      value: 'INR 50k',
      label: 'Startup competition award',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.phone_android,
      Icons.cloud_queue,
      Icons.dns_outlined,
      Icons.analytics_outlined,
    ];
    final titles = [
      'Mobile Apps',
      'Backend APIs',
      'Cloud Systems',
      'Analytics',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool twoColumns = constraints.maxWidth > 560;
        final bool wideMetrics = constraints.maxWidth > 860;
        final double metricWidth = wideMetrics
            ? (constraints.maxWidth - 24) / 4
            : twoColumns
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2B2A23),
                    Color(0xFF232323),
                    Color(0xFF1E1E1F),
                  ],
                  stops: [0.0, 0.48, 1.0],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.accent.withOpacity(0.34)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      'Engineering Profile',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.accent,
                        fontSize: 11.5,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Building scalable mobile products with clear product impact.',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 28,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    PortfolioData.about,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.5,
                      height: 1.65,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _metrics
                  .map(
                    (item) => SizedBox(
                      width: metricWidth,
                      child: _AboutMetricTile(metric: item),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 30),
            Text(
              'How I Create Value',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: PortfolioData.whatIDo.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: twoColumns ? 2 : 1,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: twoColumns ? 152 : 136,
              ),
              itemBuilder: (context, index) => _MiniCard(
                icon: icons[index],
                title: titles[index],
                description: PortfolioData.whatIDo[index],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Core Toolchain',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            _ChipWrap(items: PortfolioData.skills.take(16).toList()),
          ],
        );
      },
    );
  }
}

class _AboutMetric {
  final IconData icon;
  final String value;
  final String label;

  const _AboutMetric({
    required this.icon,
    required this.value,
    required this.label,
  });
}

class _AboutMetricTile extends StatelessWidget {
  final _AboutMetric metric;

  const _AboutMetricTile({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppTheme.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(metric.icon, color: AppTheme.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  metric.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.4,
                    color: AppTheme.muted,
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

// ─────────────────────────────────────────────────────────────
// RESUME CONTENT
// ─────────────────────────────────────────────────────────────

class _ResumeContent extends StatelessWidget {
  const _ResumeContent();

  static const List<_ResumeSnapshot> _snapshots = [
    _ResumeSnapshot(
      title: 'Current Role',
      value: 'Software Engineer',
      detail: 'SaffronEdge · Since Feb 2024',
    ),
    _ResumeSnapshot(
      title: 'Production Impact',
      value: '10,000+ Users',
      detail: 'Krishi Sanskriti on Play Store',
    ),
    _ResumeSnapshot(
      title: 'Performance Win',
      value: '60% Faster',
      detail: 'Post loading optimization',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A concise view of my delivery track record, education, and technical depth across mobile, backend, and cloud systems.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted, height: 1.7),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _snapshots
              .map((item) => _ResumeSnapshotTile(item: item))
              .toList(),
        ),
        const SizedBox(height: 34),
        _ResumeBlock(
          icon: Icons.work_outline,
          title: 'Professional Experience',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: PortfolioData.experience.map((item) {
              return _TimelineItem(
                title: item.role,
                subtitle: '${item.company} — ${item.location}',
                duration: item.duration,
                points: item.points,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 34),
        _ResumeBlock(
          icon: Icons.school_outlined,
          title: 'Education',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: PortfolioData.education.map((item) {
              return _TimelineItem(
                title: item.degree,
                subtitle: item.institute,
                duration: '${item.duration} · ${item.result}',
                points: const [],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 34),
        _ResumeBlock(
          icon: Icons.verified_outlined,
          title: 'Technical Toolkit',
          child: _ChipWrap(items: PortfolioData.skills),
        ),
        const SizedBox(height: 34),
        _ResumeBlock(
          icon: Icons.menu_book_outlined,
          title: 'Relevant Coursework',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: PortfolioData.coursework
                .map((item) => _ResumeCourseChip(label: item))
                .toList(),
          ),
        ),
        const SizedBox(height: 34),
        _ResumeBlock(
          icon: Icons.emoji_events_outlined,
          title: 'Awards and Recognition',
          child: Column(
            children: PortfolioData.achievements
                .map((a) => _BulletText(text: a))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _ResumeSnapshot {
  final String title;
  final String value;
  final String detail;

  const _ResumeSnapshot({
    required this.title,
    required this.value,
    required this.detail,
  });
}

class _ResumeSnapshotTile extends StatelessWidget {
  final _ResumeSnapshot item;

  const _ResumeSnapshotTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 220),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppTheme.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border.withOpacity(0.95)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: AppTheme.softMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.detail,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12.3,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumeCourseChip extends StatelessWidget {
  final String label;

  const _ResumeCourseChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppTheme.cardLight.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppTheme.text,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ResumeDownloadButton extends StatelessWidget {
  final Future<void> Function(String value) onOpenUrl;

  const _ResumeDownloadButton({required this.onOpenUrl});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => onOpenUrl(AppLinks.resume),
      icon: const Icon(Icons.download_outlined, size: 18),
      label: const Text('Download Resume'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.cardLight,
        foregroundColor: AppTheme.accent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppTheme.accent.withOpacity(0.35)),
        ),
        textStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PORTFOLIO CONTENT
// ─────────────────────────────────────────────────────────────

class _PortfolioContent extends StatelessWidget {
  const _PortfolioContent();

  static const List<_ProjectMetric> _impactMetrics = [
    _ProjectMetric(value: '10k+', label: 'Farmers Served'),
    _ProjectMetric(value: '8', label: 'Engineers Led'),
    _ProjectMetric(value: '60%', label: 'Faster Loads'),
    _ProjectMetric(value: 'INR 50k', label: 'Founders Award'),
  ];

  static const List<_ProjectShowcase> _projects = [
    _ProjectShowcase(
      name: 'Krishi Sanskriti',
      role: 'Team Lead and Full-Stack Engineer',
      duration: 'Feb 2024 - Present',
      summary:
          'A production agri-tech platform on Flutter and Firebase, built for farmers with commerce, expert consultations, real-time chat, and community workflows.',
      outcome: 'Deployed on Play Store and actively used by 10,000+ farmers.',
      stack: [
        'Flutter',
        'Node.js',
        'Firebase',
        'AWS EC2',
        'Kubernetes',
        'Prometheus',
      ],
      highlights: [
        'Led an 8-member engineering team and owned end-to-end delivery.',
        'Designed modular microservices and Cloud Functions for chats, offers, and geolocation targeting.',
        'Integrated Firebase Auth, FCM, Crashlytics, App Check, and Analytics.',
        'Cut feed loading time by up to 60% via optimized pagination and content interleaving.',
      ],
      icon: Icons.agriculture_outlined,
      accent: AppTheme.accent,
    ),
    _ProjectShowcase(
      name: 'PixelCNN Image Generation',
      role: 'ML Internship Project',
      duration: 'IIT Bombay | May 2023 - Oct 2023',
      summary:
          'Implemented autoregressive image synthesis using masked convolutions and pixel-wise conditional probability modeling.',
      outcome:
          'Built and trained experimental deep-learning pipelines in Google Colab.',
      stack: ['Python', 'TensorFlow', 'Google Colab'],
      highlights: [
        'Implemented PixelCNN architecture for sequential image generation.',
        'Strengthened model debugging and experimentation workflows on cloud notebooks.',
      ],
      icon: Icons.auto_awesome_outlined,
      accent: AppTheme.accent,
    ),
    _ProjectShowcase(
      name: 'Sarth Ayurveda — Clinic Management System',
      role: 'Freelance Product Engineer',
      duration: 'Freelance · Live',
      summary:
          'Built a complete clinic operations platform by replacing paper-based workflows with a Flutter, Firebase, and GCP system.',
      outcome:
          'Live production system with doctor and patient dashboards, digital prescriptions, billing, and automated reminders.',
      stack: [
        'Flutter',
        'Dart',
        'Firebase',
        'GCP',
        'WhatsApp API',
        'Realtime DB',
        'PDF Generation',
      ],
      highlights: [
        'Implemented complete patient history and records on Firebase Realtime DB.',
        'Added appointment reminders through WhatsApp API integrations.',
        'Digitized prescriptions and invoicing with PDF export workflows.',
        'Replaced manual paper workflow with zero manual data entry.',
      ],
      icon: Icons.local_hospital_outlined,
      accent: AppTheme.accent,
    ),
    _ProjectShowcase(
      name: 'KIT\'s Event Spectra',
      role: 'Project Lead',
      duration: 'Academic Team Project',
      summary:
          'Built an intelligent event-assistant chatbot and coordinated a 5-member team for seamless product integration.',
      outcome:
          'Enabled contextual event Q&A using LangChain with OpenAI GPT-3.5.',
      stack: ['Python', 'Flask', 'NLP', 'LangChain', 'OpenAI', 'React.js'],
      highlights: [
        'Led planning and execution across backend, model integration, and UI workflows.',
        'Improved user support quality through prompt-driven conversational responses.',
      ],
      icon: Icons.smart_toy_outlined,
      accent: AppTheme.accent,
    ),
    _ProjectShowcase(
      name: 'EverDry',
      role: 'Android Developer',
      duration: 'Client Product Build',
      summary:
          'Created a service and product app for Gauri Engineering Services to move offline waterproofing operations online.',
      outcome:
          'Made appointments and product discovery available through a single mobile interface.',
      stack: ['Java', 'Android Studio', 'Firebase'],
      highlights: [
        'Digitized booking flow for waterproofing consultation and scheduling.',
        'Expanded market reach with online product listing and inquiry journeys.',
      ],
      icon: Icons.water_drop_outlined,
      accent: AppTheme.accent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool twoColumns = constraints.maxWidth > 860;
        final double spacing = 18;
        final double cardWidth = twoColumns
            ? (constraints.maxWidth - spacing) / 2
            : constraints.maxWidth;

        final _ProjectShowcase featuredProject = _projects.first;
        final List<_ProjectShowcase> selectedProjects = _projects
            .skip(1)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected product work across agri-tech, conversational AI, service digitization, and ML experimentation.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.muted,
                height: 1.65,
              ),
            ),
            const SizedBox(height: 18),
            _FeaturedProjectCard(
              project: featuredProject,
              metrics: _impactMetrics,
            ),
            const SizedBox(height: 28),
            Text(
              'Project Case Studies',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: selectedProjects
                  .map(
                    (project) => SizedBox(
                      width: cardWidth,
                      child: _ProjectShowcaseCard(project: project),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

class _ProjectMetric {
  final String value;
  final String label;

  const _ProjectMetric({required this.value, required this.label});
}

class _ProjectShowcase {
  final String name;
  final String role;
  final String duration;
  final String summary;
  final String outcome;
  final List<String> stack;
  final List<String> highlights;
  final IconData icon;
  final Color accent;

  const _ProjectShowcase({
    required this.name,
    required this.role,
    required this.duration,
    required this.summary,
    required this.outcome,
    required this.stack,
    required this.highlights,
    required this.icon,
    required this.accent,
  });
}

class _FeaturedProjectCard extends StatelessWidget {
  final _ProjectShowcase project;
  final List<_ProjectMetric> metrics;

  const _FeaturedProjectCard({required this.project, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wide = constraints.maxWidth > 760;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(wide ? 26 : 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B3216), Color(0xFF24231D), Color(0xFF1E1E1F)],
              stops: [0.0, 0.45, 1.0],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppTheme.accent.withOpacity(0.35)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 30,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: AppTheme.accent.withOpacity(0.45)),
                ),
                child: Text(
                  'Featured Production Build',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.accent,
                    fontSize: 11.5,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                project.name,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${project.role} | ${project.duration}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                project.summary,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.text,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _FeatureProjectDetails(project: project)),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 250,
                      child: Column(
                        children: metrics
                            .map((metric) => _MetricTile(metric: metric))
                            .toList(),
                      ),
                    ),
                  ],
                )
              else ...[
                _FeatureProjectDetails(project: project),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: metrics
                      .map((metric) => _MetricTile(metric: metric))
                      .toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _FeatureProjectDetails extends StatelessWidget {
  final _ProjectShowcase project;

  const _FeatureProjectDetails({required this.project});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardLight.withOpacity(0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border.withOpacity(0.8)),
          ),
          child: Text(
            project.outcome,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.text),
          ),
        ),
        const SizedBox(height: 16),
        ...project.highlights
            .take(3)
            .map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: AppTheme.accent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        point,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: project.stack
              .map(
                (item) => _ProjectStackChip(label: item, tone: AppTheme.accent),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final _ProjectMetric metric;

  const _MetricTile({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppTheme.card.withOpacity(0.78),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accent.withOpacity(0.26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.accent,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric.label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.text),
          ),
        ],
      ),
    );
  }
}

class _ProjectShowcaseCard extends StatefulWidget {
  final _ProjectShowcase project;

  const _ProjectShowcaseCard({required this.project});

  @override
  State<_ProjectShowcaseCard> createState() => _ProjectShowcaseCardState();
}

class _ProjectShowcaseCardState extends State<_ProjectShowcaseCard>
    with SingleTickerProviderStateMixin {
  Offset _pointer = Offset.zero;
  Size _cardSize = Size.zero;
  bool _hovered = false;

  late final AnimationController _controller;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _glowAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent event) {
    setState(() => _hovered = true);
    _controller.forward();
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _hovered = false;
      _pointer = Offset.zero;
      _cardSize = Size.zero;
    });

    _controller.reverse();
  }

  void _onHover(PointerEvent event) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    setState(() {
      _pointer = box.globalToLocal(event.position);
      _cardSize = box.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: _onHover,
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..translate(0.0, _hovered ? -4.0 : 0.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.project.accent.withOpacity(0.12),
                  const Color(0xFF252527).withOpacity(0.95),
                  const Color(0xFF1E1E1F).withOpacity(0.98),
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.project.accent.withOpacity(
                  0.28 + 0.34 * _glowAnim.value,
                ),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.project.accent.withOpacity(
                    0.06 + 0.16 * _glowAnim.value,
                  ),
                  blurRadius: 24 + 16 * _glowAnim.value,
                  spreadRadius: 1.5,
                  offset: const Offset(0, 8),
                ),
                const BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  if (_hovered && _cardSize != Size.zero)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment(
                                (_pointer.dx / _cardSize.width) * 2 - 1,
                                (_pointer.dy / _cardSize.height) * 2 - 1,
                              ),
                              radius: 0.95,
                              colors: [
                                widget.project.accent.withOpacity(
                                  0.20 * _glowAnim.value,
                                ),
                                widget.project.accent.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(padding: const EdgeInsets.all(22), child: child!),
                ],
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _hovered
                        ? widget.project.accent.withOpacity(0.22)
                        : widget.project.accent.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.project.accent.withOpacity(
                        _hovered ? 0.58 : 0.30,
                      ),
                    ),
                  ),
                  child: Icon(
                    widget.project.icon,
                    color: widget.project.accent,
                    size: 22,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.card.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.border.withOpacity(0.85),
                    ),
                  ),
                  child: Text(
                    widget.project.duration,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.muted,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Text(
              widget.project.role,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: widget.project.accent,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.project.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.project.summary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.55,
                color: AppTheme.text,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: widget.project.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: widget.project.accent.withOpacity(0.32),
                ),
              ),
              child: Text(
                widget.project.outcome,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.text,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...widget.project.highlights
                .take(2)
                .map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: widget.project.accent,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            point,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.project.stack
                  .map(
                    (item) => _ProjectStackChip(
                      label: item,
                      tone: widget.project.accent,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectStackChip extends StatelessWidget {
  final String label;
  final Color tone;

  const _ProjectStackChip({required this.label, required this.tone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: tone.withOpacity(0.14),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tone.withOpacity(0.33)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppTheme.text,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CONTACT CONTENT
// ─────────────────────────────────────────────────────────────

class _ContactContent extends StatefulWidget {
  const _ContactContent();

  @override
  State<_ContactContent> createState() => _ContactContentState();
}

class _ContactContentState extends State<_ContactContent> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isSending = true);

    final String senderName = _nameController.text.trim();
    final String senderEmail = _emailController.text.trim();
    final String subject = _subjectController.text.trim();
    final String message = _messageController.text.trim();
    final Uri endpoint = Uri.parse(AppLinks.contactFormSubmit);

    try {
      final response = await http
          .post(
            endpoint,
            headers: const {'Accept': 'application/json'},
            body: {
              '_to': PortfolioData.email,
              'name': senderName,
              'email': senderEmail,
              'subject': subject,
              'message': message,
              '_subject': 'Portfolio Contact: $subject',
              '_replyto': senderEmail,
            },
          )
          .timeout(const Duration(seconds: 20));

      dynamic responseData;
      if (response.body.isNotEmpty) {
        try {
          responseData = jsonDecode(response.body);
        } catch (_) {
          responseData = null;
        }
      }

      final bool sent =
          response.statusCode >= 200 &&
          response.statusCode < 300 &&
          (responseData is! Map ||
              responseData['success'] == true ||
              responseData['success']?.toString().toLowerCase() == 'true');

      if (!mounted) return;

      setState(() => _isSending = false);

      if (sent) {
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent successfully.')),
        );
        return;
      }

      final String failureMessage =
          responseData is Map &&
              responseData['message'] != null &&
              responseData['message'].toString().trim().isNotEmpty
          ? responseData['message'].toString()
          : 'Could not send message right now.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failureMessage)));
    } on TimeoutException {
      if (!mounted) return;

      setState(() => _isSending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request timed out. Please check your connection.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() => _isSending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not reach form service. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMessageForm();
  }

  Widget _buildMessageForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.cardLight.withOpacity(0.74), AppTheme.card],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool twoColumns = constraints.maxWidth > 680;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send Message',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Share your project goal, timeline, and expected outcome. I will reply via email.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.muted,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                if (twoColumns)
                  Row(
                    children: [
                      Expanded(
                        child: _ContactTextField(
                          controller: _nameController,
                          hint: 'Full name',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter your full name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 22),
                      Expanded(
                        child: _ContactTextField(
                          controller: _emailController,
                          hint: 'Email address',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) return 'Enter your email address';
                            if (!text.contains('@') || !text.contains('.')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )
                else ...[
                  _ContactTextField(
                    controller: _nameController,
                    hint: 'Full name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  _ContactTextField(
                    controller: _emailController,
                    hint: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Enter your email address';
                      if (!text.contains('@') || !text.contains('.')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 22),
                _ContactTextField(
                  controller: _subjectController,
                  hint: 'Subject',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a subject';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                _ContactTextField(
                  controller: _messageController,
                  hint: 'Project brief',
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerRight,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ElevatedButton.icon(
                      onPressed: _isSending ? null : _sendMessage,
                      icon: _isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_outlined),
                      label: Text(_isSending ? 'Sending...' : 'Send Message'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.cardLight,
                        foregroundColor: AppTheme.accent,
                        disabledBackgroundColor: AppTheme.cardLight,
                        disabledForegroundColor: AppTheme.muted,
                        elevation: 14,
                        shadowColor: Colors.black.withOpacity(0.35),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: AppTheme.border.withOpacity(0.9),
                          ),
                        ),
                        textStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ContactTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _ContactTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      cursorColor: AppTheme.accent,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppTheme.text, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppTheme.softMuted,
          fontSize: 15,
        ),
        filled: true,
        fillColor: AppTheme.card,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 22,
          vertical: maxLines > 1 ? 22 : 20,
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFFF8A8A),
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppTheme.accent, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFFF8A8A)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFFF8A8A), width: 1.4),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────

class _ResumeBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _ResumeBlock({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _IconBox(icon: icon),
            const SizedBox(width: 14),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
        const SizedBox(height: 20),
        child,
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final List<String> points;

  const _TimelineItem({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardLight.withOpacity(0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: points.isEmpty ? 62 : 80,
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.7),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.text),
                ),
                const SizedBox(height: 5),
                Text(
                  duration,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (points.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...points.map((p) => _BulletText(text: p)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _MiniCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_MiniCard> createState() => _MiniCardState();
}

class _MiniCardState extends State<_MiniCard>
    with SingleTickerProviderStateMixin {
  Offset _pointer = Offset.zero;
  Size _cardSize = Size.zero;
  bool _hovered = false;
  late final AnimationController _controller;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _glowAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent e) {
    setState(() => _hovered = true);
    _controller.forward();
  }

  void _onExit(PointerEvent e) {
    setState(() => _hovered = false);
    _controller.reverse();
  }

  void _onHover(PointerEvent e) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    setState(() {
      _pointer = box.globalToLocal(e.position);
      _cardSize = box.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: _onHover,
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..translate(0.0, _hovered ? -3.0 : 0.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.accent.withOpacity(0.1),
                  const Color(0xFF2A2A2C).withOpacity(0.92),
                  const Color(0xFF1E1E1F).withOpacity(0.98),
                ],
                stops: const [0.0, 0.25, 1.0],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.accent.withOpacity(
                  0.24 + 0.32 * _glowAnim.value,
                ),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withOpacity(
                    0.06 + 0.14 * _glowAnim.value,
                  ),
                  blurRadius: 24 + 16 * _glowAnim.value,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
                const BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  if (_hovered && _cardSize != Size.zero)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment(
                                (_pointer.dx / _cardSize.width) * 2 - 1,
                                (_pointer.dy / _cardSize.height) * 2 - 1,
                              ),
                              radius: 0.9,
                              colors: [
                                AppTheme.accent.withOpacity(
                                  0.18 * _glowAnim.value,
                                ),
                                AppTheme.accent.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(padding: const EdgeInsets.all(22), child: child!),
                ],
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Icon on the left ──
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.accent.withOpacity(0.36),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(widget.icon, color: AppTheme.accent, size: 26),
            ),
            const SizedBox(width: 16),
            // ── Title + description on the right ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.5,
                      height: 1.5,
                      color: AppTheme.muted,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipWrap extends StatelessWidget {
  final List<String> items;

  const _ChipWrap({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        return _HoverSkillChip(label: item);
      }).toList(),
    );
  }
}

class _HoverSkillChip extends StatefulWidget {
  final String label;

  const _HoverSkillChip({required this.label});

  @override
  State<_HoverSkillChip> createState() => _HoverSkillChipState();
}

class _HoverSkillChipState extends State<_HoverSkillChip> {
  bool _isHovered = false;
  Offset _hoverOffset = Offset.zero;

  void _handleHover(PointerHoverEvent event) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final size = box.size;
    final local = event.localPosition;

    final dx = ((local.dx - size.width / 2) / size.width) * 6;
    final dy = ((local.dy - size.height / 2) / size.height) * 6;

    setState(() {
      _hoverOffset = Offset(dx, dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _hoverOffset = Offset.zero;
        });
      },
      onHover: _handleHover,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translate(_hoverOffset.dx, _hoverOffset.dy),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered ? AppTheme.accent : AppTheme.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppTheme.accent : AppTheme.border,
          ),
          boxShadow: _isHovered
              ? const [
                  BoxShadow(
                    color: Color(0x22FFDB70),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ]
              : const [],
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: _isHovered ? Colors.black : AppTheme.muted,
            fontWeight: FontWeight.w700,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  final String text;

  const _BulletText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(color: AppTheme.accent, fontSize: 18, height: 1.2),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  String get _subtitle {
    switch (title) {
      case 'About Me':
        return 'Who I am and how I build products';
      case 'Resume':
        return 'Experience, education, and technical depth';
      case 'Portfolio':
        return 'Selected work and measurable outcomes';
      case 'Contact':
        return '';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_subtitle.isNotEmpty) ...[
          Text(
            _subtitle.toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.softMuted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Container(
          width: 42,
          height: 5,
          decoration: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;

  const _IconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: AppTheme.accent, size: 21),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassCard({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 32,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: child,
    );
  }
}
