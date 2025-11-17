import '../../domain/entities/injury_education.dart';
import '../../domain/entities/prevention_tip.dart';
import '../../domain/entities/myth.dart';
import '../../domain/entities/glossary_term.dart';
import '../../domain/repositories/education_repository.dart';
import '../datasources/education_datasource.dart';

class EducationRepositoryImpl implements EducationRepository {
  final EducationDataSource educationDataSource;

  EducationRepositoryImpl({required this.educationDataSource});

  @override
  Future<List<InjuryEducation>> getCommonInjuries(
    String? bodyLocation,
  ) async {
    final models = await educationDataSource.getCommonInjuries(bodyLocation);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<PreventionTip>> getPreventionTips(String? sport) async {
    final models = await educationDataSource.getPreventionTips(sport);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Myth>> getMyths() async {
    final models = await educationDataSource.getMyths();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<GlossaryTerm>> getGlossary(String? searchTerm) async {
    final models = await educationDataSource.getGlossary(searchTerm);
    return models.map((model) => model.toEntity()).toList();
  }
}

