import '../entities/injury_education.dart';
import '../entities/prevention_tip.dart';
import '../entities/myth.dart';
import '../entities/glossary_term.dart';

abstract class EducationRepository {
  /// Get common injuries, optionally filtered by body location
  Future<List<InjuryEducation>> getCommonInjuries(String? bodyLocation);

  /// Get prevention tips, optionally filtered by sport
  Future<List<PreventionTip>> getPreventionTips(String? sport);

  /// Get myths about sports injuries
  Future<List<Myth>> getMyths();

  /// Get glossary terms, optionally filtered by search term
  Future<List<GlossaryTerm>> getGlossary(String? searchTerm);
}
