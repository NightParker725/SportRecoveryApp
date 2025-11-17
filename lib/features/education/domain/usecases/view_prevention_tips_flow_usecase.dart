import '../entities/prevention_tip.dart';
import '../repositories/education_repository.dart';

class ViewPreventionTipsFlowUseCase {
  final EducationRepository repository;

  ViewPreventionTipsFlowUseCase({required this.repository});

  /// Get prevention tips, optionally filtered by sport
  ///
  /// [sport] - Optional filter by sport/activity (e.g., 'Fútbol', 'Basquetbol')
  ///
  /// Returns a list of prevention tips with detailed information
  Future<List<PreventionTip>> execute(String? sport) async {
    return await repository.getPreventionTips(sport);
  }
}

