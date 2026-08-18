import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/about_overview.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/projects_overview.dart';
import '../../domain/entities/resume_details.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_local_data_source.dart';
import '../models/about_overview_model.dart';
import '../models/resume_details_model.dart';

/// Serves portfolio content from the local data source, translating parsing
/// errors into [ContentFailure].
class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource _localDataSource;

  const PortfolioRepositoryImpl(this._localDataSource);

  @override
  Future<Result<Profile>> getProfile() async {
    return _guard(() => _localDataSource.getProfile().toEntity());
  }

  @override
  Future<Result<AboutOverview>> getAboutOverview() async {
    return _guard(() {
      final AboutOverviewModel about = _localDataSource.getAboutOverview();
      final ResumeDetailsModel resume = _localDataSource.getResumeDetails();

      // The "Core Toolchain" is the leading slice of the full skill list, so
      // the two tabs can never disagree about the skills themselves.
      final int count = about.coreSkillCount.clamp(0, resume.skills.length);

      return about.toEntity(
        coreSkills: resume.skills.take(count).toList(growable: false),
      );
    });
  }

  @override
  Future<Result<ResumeDetails>> getResumeDetails() async {
    return _guard(() => _localDataSource.getResumeDetails().toEntity());
  }

  @override
  Future<Result<ProjectsOverview>> getProjectsOverview() async {
    return _guard(() => _localDataSource.getProjectsOverview().toEntity());
  }

  Result<T> _guard<T>(T Function() read) {
    try {
      return Result<T>.success(read());
    } on ContentParsingException catch (exception) {
      return Result<T>.failure(ContentFailure(exception.message));
    } on Object catch (error) {
      return Result<T>.failure(
        UnexpectedFailure('Portfolio content could not be read: $error'),
      );
    }
  }
}
