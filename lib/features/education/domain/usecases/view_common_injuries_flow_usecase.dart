import '../entities/injury_education.dart';
import '../repositories/education_repository.dart';

class ViewCommonInjuriesFlowUseCase {
  final EducationRepository repository;

  ViewCommonInjuriesFlowUseCase({required this.repository});

  /// Get common injuries, optionally filtered by body location
  ///
  /// [bodyLocation] - Optional filter by body location (e.g., 'Rodilla', 'Tobillo')
  ///
  /// Returns a list of common injuries with detailed information
  Future<List<InjuryEducation>> execute(String? bodyLocation) async {
    return await repository.getCommonInjuries(bodyLocation);
  }
}

