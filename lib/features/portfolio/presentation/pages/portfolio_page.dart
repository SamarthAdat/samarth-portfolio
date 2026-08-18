import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/widgets/particle_background/particle_background.dart';
import '../controllers/contact_form_controller.dart';
import '../controllers/portfolio_controller.dart';
import '../widgets/layout/main_panel.dart';
import '../widgets/sidebar/profile_sidebar.dart';

/// The portfolio screen.
///
/// It receives ready-made controllers, so it holds no business logic of its
/// own: it wires callbacks, listens for changes, and lays the pieces out.
class PortfolioPage extends StatefulWidget {
  final PortfolioController controller;
  final ContactFormController contactFormController;

  const PortfolioPage({
    super.key,
    required this.controller,
    required this.contactFormController,
  });

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  Future<void> _openLink(String url) async {
    _reportIfFailed(await widget.controller.openLink(url));
  }

  Future<void> _downloadResume() async {
    _reportIfFailed(await widget.controller.openResume());
  }

  void _reportIfFailed(Failure? failure) {
    if (failure == null || !mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failure.message)));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final bool isDesktop = size.width >= AppConfig.desktopBreakpoint;

    return Scaffold(
      // The constellation sits behind the whole page; the layout above it is
      // unchanged and keeps its own opaque cards.
      body: ParticleBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 28 : 16),
                child: ListenableBuilder(
                  listenable: widget.controller,
                  builder: (BuildContext context, _) =>
                      isDesktop ? _buildDesktop(context) : _buildMobile(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    final double sidebarHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).top -
        MediaQuery.paddingOf(context).bottom -
        56;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 310, height: sidebarHeight, child: _buildSidebar()),
        const SizedBox(width: 28),
        Expanded(child: _buildPanel(isDesktop: true)),
      ],
    );
  }

  Widget _buildMobile() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildSidebar(),
          const SizedBox(height: 18),
          _buildPanel(isDesktop: false),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return ProfileSidebar(
      state: widget.controller.profile,
      onOpenLink: _openLink,
    );
  }

  Widget _buildPanel({required bool isDesktop}) {
    return MainPanel(
      controller: widget.controller,
      contactFormController: widget.contactFormController,
      isDesktop: isDesktop,
      onDownloadResume: _downloadResume,
    );
  }
}
