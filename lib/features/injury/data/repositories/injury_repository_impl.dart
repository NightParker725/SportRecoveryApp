import '../../domain/entities/injury_assessment.dart';
import '../../domain/repositories/injury_repository.dart';
import '../datasources/injury_data_source.dart';

class InjuryRepositoryImpl implements InjuryRepository {
  final InjuryDataSource injuryDataSource;

  InjuryRepositoryImpl({required this.injuryDataSource});

  @override
  Future<InjuryAssessment> saveAssessment(InjuryAssessment assessment) async {
    return await injuryDataSource.saveAssessment(assessment);
  }

  @override
  Future<InjuryAssessment> getAssessmentById(String assessmentId) async {
    return await injuryDataSource.getAssessmentById(assessmentId);
  }

  @override
  Future<List<InjuryAssessment>> getUserAssessments(String userId) async {
    return await injuryDataSource.getUserAssessments(userId);
  }

  @override
  Future<void> deleteAssessment(String assessmentId) async {
    return await injuryDataSource.deleteAssessment(assessmentId);
  }

  @override
  Future<List<InjuryAssessment>> getRecentAssessments(
    String userId,
    int limit,
  ) async {
    return await injuryDataSource.getRecentAssessments(userId, limit);
  }
}
