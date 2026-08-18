import 'package:flutter/material.dart';

import '../core/di/service_locator.dart';
import '../core/theme/app_theme.dart';
import '../features/portfolio/presentation/controllers/contact_form_controller.dart';
import '../features/portfolio/presentation/controllers/portfolio_controller.dart';
import '../features/portfolio/presentation/pages/portfolio_page.dart';

/// Root widget.
///
/// It resolves the screen's controllers once and owns their lifetime, keeping
/// the service locator out of every widget below.
class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late final PortfolioController _portfolioController =
      sl.get<PortfolioController>();
  late final ContactFormController _contactFormController =
      sl.get<ContactFormController>();

  @override
  void dispose() {
    _portfolioController.dispose();
    _contactFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Samarth Adat | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: PortfolioPage(
        controller: _portfolioController,
        contactFormController: _contactFormController,
      ),
    );
  }
}
