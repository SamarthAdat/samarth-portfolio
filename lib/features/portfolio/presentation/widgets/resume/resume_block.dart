import 'package:flutter/material.dart';

import '../../mappers/portfolio_icons.dart';
import '../common/icon_box.dart';

/// A titled block of the resume: icon, heading, and body.
class ResumeBlock extends StatelessWidget {
  final ResumeSectionKind section;
  final String title;
  final Widget child;

  const ResumeBlock({
    super.key,
    required this.section,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconBox(icon: PortfolioIcons.forResumeSection(section)),
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
