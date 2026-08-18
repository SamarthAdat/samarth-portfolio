import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/about_overview.dart';
import '../repositories/portfolio_repository.dart';

/// Loads the content of the About tab.
class GetAboutOverview implements UseCase<AboutOverview, NoParams> {
  final PortfolioRepository _repository;

  const GetAboutOverview(this._repository);

  @override
  Future<Result<AboutOverview>> call(NoParams params) =>
      _repository.getAboutOverview();
}
