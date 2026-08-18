import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/about_overview.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/projects_overview.dart';
import '../../domain/entities/resume_details.dart';
import '../../domain/usecases/download_resume.dart';
import '../../domain/usecases/get_about_overview.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/get_projects_overview.dart';
import '../../domain/usecases/get_resume_details.dart';
import '../../domain/usecases/open_external_link.dart';
import '../state/portfolio_tab.dart';
import '../state/view_state.dart';

/// Drives the portfolio screen: which tab is active, the content of each
/// section, and requests to open external destinations.
///
/// It talks only to use cases, so it can be exercised in tests without HTTP,
/// plugins, or the widget tree.
class PortfolioController extends ChangeNotifier {
  final GetProfile _getProfile;
  final GetAboutOverview _getAboutOverview;
  final GetResumeDetails _getResumeDetails;
  final GetProjectsOverview _getProjectsOverview;
  final OpenExternalLink _openExternalLink;
  final DownloadResume _downloadResume;

  PortfolioController({
    required GetProfile getProfile,
    required GetAboutOverview getAboutOverview,
    required GetResumeDetails getResumeDetails,
    required GetProjectsOverview getProjectsOverview,
    required OpenExternalLink openExternalLink,
    required DownloadResume downloadResume,
  }) : _getProfile = getProfile,
       _getAboutOverview = getAboutOverview,
       _getResumeDetails = getResumeDetails,
       _getProjectsOverview = getProjectsOverview,
       _openExternalLink = openExternalLink,
       _downloadResume = downloadResume;

  PortfolioTab _selectedTab = PortfolioTab.about;
  ViewState<Profile> _profile = const ViewState<Profile>.loading();
  ViewState<AboutOverview> _about = const ViewState<AboutOverview>.loading();
  ViewState<ResumeDetails> _resume = const ViewState<ResumeDetails>.loading();
  ViewState<ProjectsOverview> _projects =
      const ViewState<ProjectsOverview>.loading();

  PortfolioTab get selectedTab => _selectedTab;
  ViewState<Profile> get profile => _profile;
  ViewState<AboutOverview> get about => _about;
  ViewState<ResumeDetails> get resume => _resume;
  ViewState<ProjectsOverview> get projects => _projects;

  /// Loads every section up front. Content is bundled with the app, so this
  /// resolves immediately and tab switches never show a spinner.
  Future<void> load() async {
    final (
      Result<Profile> profileResult,
      Result<AboutOverview> aboutResult,
      Result<ResumeDetails> resumeResult,
      Result<ProjectsOverview> projectsResult,
    ) = await (
      _getProfile(const NoParams()),
      _getAboutOverview(const NoParams()),
      _getResumeDetails(const NoParams()),
      _getProjectsOverview(const NoParams()),
    ).wait;

    _profile = ViewState<Profile>.fromResult(profileResult);
    _about = ViewState<AboutOverview>.fromResult(aboutResult);
    _resume = ViewState<ResumeDetails>.fromResult(resumeResult);
    _projects = ViewState<ProjectsOverview>.fromResult(projectsResult);

    notifyListeners();
  }

  void selectTab(PortfolioTab tab) {
    if (tab == _selectedTab) return;
    _selectedTab = tab;
    notifyListeners();
  }

  /// Opens [url], returning the failure to report to the user, or `null` on
  /// success.
  Future<Failure?> openLink(String url) async {
    final Result<void> result = await _openExternalLink(url);
    return result.failureOrNull;
  }

  /// Opens the resume PDF, returning a failure to report, or `null`.
  Future<Failure?> openResume() async {
    final Result<void> result = await _downloadResume(const NoParams());
    return result.failureOrNull;
  }
}
