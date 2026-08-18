import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/projects_overview.dart';
import '../repositories/portfolio_repository.dart';

/// Loads the content of the Portfolio tab.
class GetProjectsOverview implements UseCase<ProjectsOverview, NoParams> {
  final PortfolioRepository _repository;

  const GetProjectsOverview(this._repository);

  @override
  Future<Result<ProjectsOverview>> call(NoParams params) =>
      _repository.getProjectsOverview();
}
