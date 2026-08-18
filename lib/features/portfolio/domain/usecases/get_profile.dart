import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/profile.dart';
import '../repositories/portfolio_repository.dart';

/// Loads the identity and contact channels shown in the sidebar.
class GetProfile implements UseCase<Profile, NoParams> {
  final PortfolioRepository _repository;

  const GetProfile(this._repository);

  @override
  Future<Result<Profile>> call(NoParams params) => _repository.getProfile();
}
