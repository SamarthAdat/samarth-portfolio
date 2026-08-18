import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/education.dart';
import '../../../domain/entities/experience.dart';
import '../../../domain/entities/resume_details.dart';
import '../../../domain/entities/resume_highlight.dart';
import '../../mappers/portfolio_icons.dart';
import '../../state/view_state.dart';
import '../common/bullet_text.dart';
import '../common/skill_chip_wrap.dart';
import '../common/view_state_builder.dart';
import 'course_chip.dart';
import 'resume_block.dart';
import 'resume_highlight_tile.dart';
import 'timeline_item.dart';

/// Body of the Resume tab.
class ResumeSection extends StatelessWidget {
  final ViewState<ResumeDetails> state;

  const ResumeSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ViewStateBuilder<ResumeDetails>(
      state: state,
      builder: (BuildContext context, ResumeDetails details) =>
          _ResumeBody(details: details),
    );
  }
}

class _ResumeBody extends StatelessWidget {
  static const double _blockSpacing = 34;

  final ResumeDetails details;

  const _ResumeBody({required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          details.intro,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.muted, height: 1.7),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: details.highlights
              .map(
                (ResumeHighlight highlight) =>
                    ResumeHighlightTile(highlight: highlight),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: _blockSpacing),
        ResumeBlock(
          section: ResumeSectionKind.experience,
          title: 'Professional Experience',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: details.experiences
                .map(
                  (Experience experience) => TimelineItem(
                    title: experience.role,
                    subtitle: experience.subtitle,
                    duration: experience.duration,
                    points: experience.points,
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: _blockSpacing),
        ResumeBlock(
          section: ResumeSectionKind.education,
          title: 'Education',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: details.education
                .map(
                  (Education education) => TimelineItem(
                    title: education.degree,
                    subtitle: education.institute,
                    duration: education.durationWithResult,
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: _blockSpacing),
        ResumeBlock(
          section: ResumeSectionKind.toolkit,
          title: 'Technical Toolkit',
          child: SkillChipWrap(items: details.skills),
        ),
        const SizedBox(height: _blockSpacing),
        ResumeBlock(
          section: ResumeSectionKind.coursework,
          title: 'Relevant Coursework',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: details.coursework
                .map((String course) => CourseChip(label: course))
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: _blockSpacing),
        ResumeBlock(
          section: ResumeSectionKind.awards,
          title: 'Awards and Recognition',
          child: Column(
            children: details.achievements
                .map((String award) => BulletText(text: award))
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
