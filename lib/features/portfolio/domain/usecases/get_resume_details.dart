import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/resume_details.dart';
import '../repositories/portfolio_repository.dart';

/// Loads the content of the Resume tab.
class GetResumeDetails implements UseCase<ResumeDetails, NoParams> {
  final PortfolioRepository _repository;

  const GetResumeDetails(this._repository);

  @override
  Future<Result<ResumeDetails>> call(NoParams params) =>
      _repository.getResumeDetails();
}
