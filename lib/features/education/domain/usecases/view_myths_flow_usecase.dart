import '../entities/myth.dart';
import '../repositories/education_repository.dart';

class ViewMythsFlowUseCase {
  final EducationRepository repository;

  ViewMythsFlowUseCase({required this.repository});

  /// Get myths about sports injuries
  ///
  /// Returns a list of common myths with their explanations
  /// and the scientific reality
  Future<List<Myth>> execute() async {
    return await repository.getMyths();
  }
}

