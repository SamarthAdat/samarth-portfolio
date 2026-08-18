import 'package:flutter_test/flutter_test.dart';
import 'package:samarth_portfolio/core/error/failure.dart';
import 'package:samarth_portfolio/core/utils/result.dart';
import 'package:samarth_portfolio/features/portfolio/data/datasources/portfolio_local_data_source.dart';
import 'package:samarth_portfolio/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:samarth_portfolio/features/portfolio/domain/entities/about_overview.dart';
import 'package:samarth_portfolio/features/portfolio/domain/entities/profile.dart';
import 'package:samarth_portfolio/features/portfolio/domain/entities/project.dart';
import 'package:samarth_portfolio/features/portfolio/domain/entities/projects_overview.dart';
import 'package:samarth_portfolio/features/portfolio/domain/entities/resume_details.dart';
import 'package:samarth_portfolio/features/portfolio/domain/repositories/portfolio_repository.dart';

void main() {
  late PortfolioRepository repository;

  setUp(() {
    repository = PortfolioRepositoryImpl(PortfolioLocalDataSourceImpl());
  });

  group('bundled content', () {
    test('parses the profile with its contact channels', () async {
      final Result<Profile> result = await repository.getProfile();

      final Profile profile = result.valueOrNull!;
      expect(profile.fullName, 'Samarth Vishnu Adat');
      expect(profile.email, 'samarthadat2002@gmail.com');
      expect(profile.channels, hasLength(5));
      expect(
        profile.channels.first.actionUrl,
        'mailto:samarthadat2002@gmail.com',
      );
    });

    test('parses the resume', () async {
      final Result<ResumeDetails> result = await repository.getResumeDetails();

      final ResumeDetails details = result.valueOrNull!;
      expect(details.experiences, hasLength(2));
      expect(details.education, hasLength(2));
      expect(details.skills, hasLength(31));
      expect(details.achievements, hasLength(2));
    });

    test('derives core skills from the leading slice of the skill list', () async {
      final AboutOverview about = (await repository.getAboutOverview())
          .valueOrNull!;
      final ResumeDetails resume = (await repository.getResumeDetails())
          .valueOrNull!;

      expect(about.coreSkills, hasLength(16));
      expect(about.coreSkills, resume.skills.take(16));
      expect(about.metrics, hasLength(4));
      expect(about.valuePropositions, hasLength(4));
    });

    test('separates the featured project from the case studies', () async {
      final ProjectsOverview overview =
          (await repository.getProjectsOverview()).valueOrNull!;

      expect(overview.featured?.name, 'Krishi Sanskriti');
      expect(overview.caseStudies, hasLength(4));
      expect(
        overview.caseStudies.every((Project project) => !project.isFeatured),
        isTrue,
      );
      expect(overview.impactMetrics, hasLength(4));
    });
  });

  group('malformed content', () {
    test('reports a ContentFailure instead of throwing', () async {
      final PortfolioRepository broken = PortfolioRepositoryImpl(
        PortfolioLocalDataSourceImpl(
          content: const <String, dynamic>{
            'profile': <String, dynamic>{'fullName': 42},
          },
        ),
      );

      final Result<Profile> result = await broken.getProfile();

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ContentFailure>());
    });

    test('reports a ContentFailure when a section is missing', () async {
      final PortfolioRepository broken = PortfolioRepositoryImpl(
        PortfolioLocalDataSourceImpl(content: const <String, dynamic>{}),
      );

      expect((await broken.getResumeDetails()).isFailure, isTrue);
    });
  });
}
