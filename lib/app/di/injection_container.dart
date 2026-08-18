import 'package:http/http.dart' as http;

import '../../core/di/service_locator.dart';
import '../../features/portfolio/data/datasources/contact_remote_data_source.dart';
import '../../features/portfolio/data/datasources/link_launcher_data_source.dart';
import '../../features/portfolio/data/datasources/portfolio_local_data_source.dart';
import '../../features/portfolio/data/repositories/contact_repository_impl.dart';
import '../../features/portfolio/data/repositories/link_repository_impl.dart';
import '../../features/portfolio/data/repositories/portfolio_repository_impl.dart';
import '../../features/portfolio/domain/repositories/contact_repository.dart';
import '../../features/portfolio/domain/repositories/link_repository.dart';
import '../../features/portfolio/domain/repositories/portfolio_repository.dart';
import '../../features/portfolio/domain/usecases/download_resume.dart';
import '../../features/portfolio/domain/usecases/get_about_overview.dart';
import '../../features/portfolio/domain/usecases/get_profile.dart';
import '../../features/portfolio/domain/usecases/get_projects_overview.dart';
import '../../features/portfolio/domain/usecases/get_resume_details.dart';
import '../../features/portfolio/domain/usecases/open_external_link.dart';
import '../../features/portfolio/domain/usecases/send_contact_message.dart';
import '../../features/portfolio/presentation/controllers/contact_form_controller.dart';
import '../../features/portfolio/presentation/controllers/portfolio_controller.dart';

/// The composition root.
///
/// This is the only place where concrete implementations are chosen: every
/// other file depends on the abstractions registered here. Swapping the local
/// content source for an API is a change to this file plus one data source.
void configureDependencies() {
  _registerExternal();
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerControllers();
}

void _registerExternal() {
  sl.registerLazySingleton<http.Client>(http.Client.new);
}

void _registerDataSources() {
  sl.registerLazySingleton<PortfolioLocalDataSource>(
    PortfolioLocalDataSourceImpl.new,
  );
  sl.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSourceImpl(client: sl.get<http.Client>()),
  );
  sl.registerLazySingleton<LinkLauncherDataSource>(UrlLauncherDataSource.new);
}

void _registerRepositories() {
  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(sl.get<PortfolioLocalDataSource>()),
  );
  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(
      remoteDataSource: sl.get<ContactRemoteDataSource>(),
      localDataSource: sl.get<PortfolioLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<LinkRepository>(
    () => LinkRepositoryImpl(sl.get<LinkLauncherDataSource>()),
  );
}

void _registerUseCases() {
  sl.registerLazySingleton<GetProfile>(
    () => GetProfile(sl.get<PortfolioRepository>()),
  );
  sl.registerLazySingleton<GetAboutOverview>(
    () => GetAboutOverview(sl.get<PortfolioRepository>()),
  );
  sl.registerLazySingleton<GetResumeDetails>(
    () => GetResumeDetails(sl.get<PortfolioRepository>()),
  );
  sl.registerLazySingleton<GetProjectsOverview>(
    () => GetProjectsOverview(sl.get<PortfolioRepository>()),
  );
  sl.registerLazySingleton<SendContactMessage>(
    () => SendContactMessage(sl.get<ContactRepository>()),
  );
  sl.registerLazySingleton<OpenExternalLink>(
    () => OpenExternalLink(sl.get<LinkRepository>()),
  );
  sl.registerLazySingleton<DownloadResume>(
    () => DownloadResume(sl.get<LinkRepository>()),
  );
}

/// Controllers are factories: each screen gets its own instance and disposes
/// it, rather than sharing mutable state through the locator.
void _registerControllers() {
  sl.registerFactory<PortfolioController>(
    () => PortfolioController(
      getProfile: sl.get<GetProfile>(),
      getAboutOverview: sl.get<GetAboutOverview>(),
      getResumeDetails: sl.get<GetResumeDetails>(),
      getProjectsOverview: sl.get<GetProjectsOverview>(),
      openExternalLink: sl.get<OpenExternalLink>(),
      downloadResume: sl.get<DownloadResume>(),
    ),
  );
  sl.registerFactory<ContactFormController>(
    () => ContactFormController(
      sendContactMessage: sl.get<SendContactMessage>(),
    ),
  );
}
