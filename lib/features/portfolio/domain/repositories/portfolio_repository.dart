import '../../../../core/utils/result.dart';
import '../entities/about_overview.dart';
import '../entities/profile.dart';
import '../entities/projects_overview.dart';
import '../entities/resume_details.dart';

/// Read access to the portfolio's content.
///
/// The domain declares this contract; the data layer decides whether content
/// comes from a bundled file, an API, or a CMS.
abstract interface class PortfolioRepository {
  Future<Result<Profile>> getProfile();

  Future<Result<AboutOverview>> getAboutOverview();

  Future<Result<ResumeDetails>> getResumeDetails();

  Future<Result<ProjectsOverview>> getProjectsOverview();
}
