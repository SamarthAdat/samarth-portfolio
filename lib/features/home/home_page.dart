import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final uri = Uri.parse(value);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final bool isDesktop = width >= 980;

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
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 310,
                            maxHeight:
                                MediaQuery.sizeOf(context).height -
                                MediaQuery.paddingOf(context).top -
                                MediaQuery.paddingOf(context).bottom -
                                56,
                          ),
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
        return _ContactContent(onOpenUrl: onOpenUrl);
    }
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle(_title),
                          const SizedBox(height: 26),
                          _buildContent(),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _SectionTitle(_title),
                        const SizedBox(height: 26),
                        _buildContent(),
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
// TOP NAVIGATION TABS
// ─────────────────────────────────────────────────────────────

class _TopNavigation extends StatelessWidget {
  final PortfolioTab selectedTab;
  final ValueChanged<PortfolioTab> onTabChanged;

  const _TopNavigation({required this.selectedTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    final tabs = {
      PortfolioTab.about: 'About',
      PortfolioTab.resume: 'Resume',
      PortfolioTab.portfolio: 'Portfolio',
      PortfolioTab.contact: 'Contact',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF222224),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.entries.map((entry) {
            final bool selected = entry.key == selectedTab;
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: TextButton(
                onPressed: () => onTabChanged(entry.key),
                style: TextButton.styleFrom(
                  foregroundColor: selected ? AppTheme.accent : AppTheme.muted,
                  backgroundColor: selected
                      ? AppTheme.accent.withOpacity(0.1)
                      : Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 13.5,
                  ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          PortfolioData.about,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            height: 1.65,
            color: AppTheme.muted,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "What I'm Doing",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final bool twoColumns = constraints.maxWidth > 560;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: PortfolioData.whatIDo.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: twoColumns ? 2 : 1,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                // Fixed height per card — no Expanded needed anywhere.
                mainAxisExtent: 130,
              ),
              itemBuilder: (context, index) => _MiniCard(
                icon: icons[index],
                title: titles[index],
                description: PortfolioData.whatIDo[index],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// RESUME CONTENT
// ─────────────────────────────────────────────────────────────

class _ResumeContent extends StatelessWidget {
  const _ResumeContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ResumeBlock(
          icon: Icons.work_outline,
          title: 'Experience',
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
          title: 'Technical Skills',
          child: _ChipWrap(items: PortfolioData.skills),
        ),
        const SizedBox(height: 34),
        _ResumeBlock(
          icon: Icons.emoji_events_outlined,
          title: 'Achievements',
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

// ─────────────────────────────────────────────────────────────
// PORTFOLIO CONTENT
// ─────────────────────────────────────────────────────────────

class _PortfolioContent extends StatelessWidget {
  const _PortfolioContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool twoColumns = constraints.maxWidth > 560;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: PortfolioData.projects.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: twoColumns ? 2 : 1,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            mainAxisExtent: 240,
          ),
          itemBuilder: (context, index) {
            final project = PortfolioData.projects[index];

            return _ProjectHoverCard(project: project);
          },
        );
      },
    );
  }
}

class _ProjectHoverCard extends StatefulWidget {
  final Project project;

  const _ProjectHoverCard({required this.project});

  @override
  State<_ProjectHoverCard> createState() => _ProjectHoverCardState();
}

class _ProjectHoverCardState extends State<_ProjectHoverCard>
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
                  const Color(0xFF2E2E30).withOpacity(0.88),
                  const Color(0xFF1E1E1F).withOpacity(0.96),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.accent.withOpacity(
                  0.18 + 0.34 * _glowAnim.value,
                ),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withOpacity(
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
                                AppTheme.accent.withOpacity(
                                  0.20 * _glowAnim.value,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _hovered
                    ? AppTheme.accent.withOpacity(0.18)
                    : AppTheme.accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.accent.withOpacity(_hovered ? 0.55 : 0.28),
                ),
              ),
              child: const Icon(
                Icons.folder_open,
                color: AppTheme.accent,
                size: 22,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.project.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.project.stack,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.accent,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                widget.project.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.55),
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CONTACT CONTENT
// ─────────────────────────────────────────────────────────────

class _ContactContent extends StatefulWidget {
  final Future<void> Function(String value) onOpenUrl;

  const _ContactContent({required this.onOpenUrl});

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

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (entry) =>
              '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}',
        )
        .join('&');
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    final String senderName = _nameController.text.trim();
    final String senderEmail = _emailController.text.trim();
    final String subject = _subjectController.text.trim();
    final String message = _messageController.text.trim();

    final String body =
        '''
Name: $senderName
Email: $senderEmail

Message:
$message
''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: PortfolioData.email,
      query: _encodeQueryParameters({'subject': subject, 'body': body}),
    );

    final bool launched = await launchUrl(
      emailUri,
      mode: LaunchMode.externalApplication,
    );

    if (!mounted) return;

    setState(() => _isSending = false);

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open email app. Please try manually.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool twoColumns = MediaQuery.sizeOf(context).width > 760;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            hint: 'Your Message',
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
                label: Text(_isSending ? 'Opening Mail...' : 'Send Message'),
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
                    side: BorderSide(color: AppTheme.border.withOpacity(0.9)),
                  ),
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.only(left: 18),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: AppTheme.accent.withOpacity(0.5), width: 2),
        ),
      ),
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
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2E2E30).withOpacity(0.85),
                  const Color(0xFF1E1E1F).withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.accent.withOpacity(
                  0.18 + 0.32 * _glowAnim.value,
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
                color: AppTheme.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.accent.withOpacity(0.3),
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
                      letterSpacing: -0.2,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
