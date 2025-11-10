import '../entities/injury_assessment.dart';

abstract class InjuryRepository {
  Future<InjuryAssessment> saveAssessment(InjuryAssessment assessment);
  Future<InjuryAssessment> getAssessmentById(String assessmentId);
  Future<List<InjuryAssessment>> getUserAssessments(String userId);
  Future<void> deleteAssessment(String assessmentId);
  Future<List<InjuryAssessment>> getRecentAssessments(String userId, int limit);
}
