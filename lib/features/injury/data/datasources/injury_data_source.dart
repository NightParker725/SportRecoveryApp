import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/injury_assessment.dart';

abstract class InjuryDataSource {
  Future<InjuryAssessment> saveAssessment(InjuryAssessment assessment);
  Future<InjuryAssessment> getAssessmentById(String assessmentId);
  Future<List<InjuryAssessment>> getUserAssessments(String userId);
  Future<void> deleteAssessment(String assessmentId);
  Future<List<InjuryAssessment>> getRecentAssessments(String userId, int limit);
}

class InjuryDataSourceImpl implements InjuryDataSource {
  final SupabaseClient supabaseClient;

  InjuryDataSourceImpl({required this.supabaseClient});

  @override
  Future<InjuryAssessment> saveAssessment(InjuryAssessment assessment) async {
    try {
      final data = assessment.toJson();
      final response = await supabaseClient
          .from('injury_assessments')
          .insert(data)
          .select()
          .single();

      return InjuryAssessment.fromJson(response);
    } catch (e) {
      throw Exception('Error al guardar la evaluación de lesión: $e');
    }
  }

  @override
  Future<InjuryAssessment> getAssessmentById(String assessmentId) async {
    try {
      final response = await supabaseClient
          .from('injury_assessments')
          .select()
          .eq('id', assessmentId)
          .single();

      return InjuryAssessment.fromJson(response);
    } catch (e) {
      throw Exception('Error al obtener la evaluación: $e');
    }
  }

  @override
  Future<List<InjuryAssessment>> getUserAssessments(String userId) async {
    try {
      final response = await supabaseClient
          .from('injury_assessments')
          .select()
          .eq('userId', userId)
          .order('createdAt', ascending: false);

      return (response as List)
          .map((item) => InjuryAssessment.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener evaluaciones del usuario: $e');
    }
  }

  @override
  Future<void> deleteAssessment(String assessmentId) async {
    try {
      await supabaseClient
          .from('injury_assessments')
          .delete()
          .eq('id', assessmentId);
    } catch (e) {
      throw Exception('Error al eliminar la evaluación: $e');
    }
  }

  @override
  Future<List<InjuryAssessment>> getRecentAssessments(
    String userId,
    int limit,
  ) async {
    try {
      final response = await supabaseClient
          .from('injury_assessments')
          .select()
          .eq('userId', userId)
          .order('createdAt', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => InjuryAssessment.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener evaluaciones recientes: $e');
    }
  }
}
