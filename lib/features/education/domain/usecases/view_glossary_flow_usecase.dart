import '../entities/glossary_term.dart';
import '../repositories/education_repository.dart';

class ViewGlossaryFlowUseCase {
  final EducationRepository repository;

  ViewGlossaryFlowUseCase({required this.repository});

  /// Get glossary terms, optionally filtered by search term
  ///
  /// [searchTerm] - Optional search term to filter glossary entries
  /// Searches in term name and definition
  ///
  /// Returns a list of glossary terms with definitions and examples
  Future<List<GlossaryTerm>> execute(String? searchTerm) async {
    return await repository.getGlossary(searchTerm);
  }
}

