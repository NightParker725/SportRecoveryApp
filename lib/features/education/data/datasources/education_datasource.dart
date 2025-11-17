import '../models/injury_education_model.dart';
import '../models/prevention_tip_model.dart';
import '../models/myth_model.dart';
import '../models/glossary_term_model.dart';

abstract class EducationDataSource {
  /// Get common injuries, optionally filtered by body location
  Future<List<InjuryEducationModel>> getCommonInjuries(String? bodyLocation);

  /// Get prevention tips, optionally filtered by sport
  Future<List<PreventionTipModel>> getPreventionTips(String? sport);

  /// Get myths about sports injuries
  Future<List<MythModel>> getMyths();

  /// Get glossary terms, optionally filtered by search term
  Future<List<GlossaryTermModel>> getGlossary(String? searchTerm);
}
