import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/json_reader.dart';
import '../models/about_overview_model.dart';
import '../models/profile_model.dart';
import '../models/projects_overview_model.dart';
import '../models/resume_details_model.dart';
import 'local/portfolio_content.dart';

/// Reads the portfolio content bundled with the app.
abstract interface class PortfolioLocalDataSource {
  ProfileModel getProfile();

  AboutOverviewModel getAboutOverview();

  ResumeDetailsModel getResumeDetails();

  ProjectsOverviewModel getProjectsOverview();
}

/// Parses [kPortfolioContent] into models, caching each section after its
/// first read so repeated tab switches do not re-parse the payload.
class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  final Map<String, dynamic> _content;

  ProfileModel? _profile;
  AboutOverviewModel? _about;
  ResumeDetailsModel? _resume;
  ProjectsOverviewModel? _projects;

  PortfolioLocalDataSourceImpl({Map<String, dynamic> content = kPortfolioContent})
    : _content = content;

  @override
  ProfileModel getProfile() =>
      _profile ??= ProfileModel.fromJson(_section('profile'));

  @override
  AboutOverviewModel getAboutOverview() =>
      _about ??= AboutOverviewModel.fromJson(_section('about'));

  @override
  ResumeDetailsModel getResumeDetails() =>
      _resume ??= ResumeDetailsModel.fromJson(_section('resume'));

  @override
  ProjectsOverviewModel getProjectsOverview() =>
      _projects ??= ProjectsOverviewModel.fromJson(_section('projects'));

  Map<String, dynamic> _section(String key) {
    if (!_content.containsKey(key)) {
      throw ContentParsingException(
        'Portfolio content is missing the "$key" section.',
      );
    }
    return _content.requireObject(key);
  }
}
