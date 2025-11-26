import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/injury_evaluation_model.dart';
import '../models/recovery_plan_model.dart';
import '../models/recovery_phase_model.dart';
import '../models/recovery_task_model.dart';
import '../models/recovery_video_model.dart';
import '../models/recovery_progress_model.dart';
import '../models/recovery_task_completion_model.dart';

class RecoveryRemoteDataSource {
  final _db = Supabase.instance.client;

  Future<InjuryEvaluationModel?> getLatestInjuryForUser(String userId) async {
    final res = await _db
        .from('injury_evaluations')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (res == null) return null;
    return InjuryEvaluationModel.fromJson(Map<String, dynamic>.from(res));
  }

  Future<RecoveryPlanModel?> getPlanByInjury(String injuryId) async {
    final res = await _db
        .from('recovery_plans')
        .select()
        .eq('injury_id', injuryId)
        .maybeSingle();

    if (res == null) return null;
    return RecoveryPlanModel.fromJson(Map<String, dynamic>.from(res));
  }

  Future<List<RecoveryPhaseModel>> getPhasesByPlan(String planId) async {
    final res = await _db
        .from('recovery_phases')
        .select()
        .eq('plan_id', planId);

    print(" RAW phases response: $res");
    return (res as List)
        .map((e) => RecoveryPhaseModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<RecoveryTaskModel>> getTasksByPhase(String phaseId) async {
    final res = await _db
        .from('recovery_tasks')
        .select()
        .eq('phase_id', phaseId)
        .order('day_index');

    return (res as List)
        .map((e) => RecoveryTaskModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<RecoveryVideoModel?> getVideoById(String id) async {
    final res = await _db
        .from('recovery_videos')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (res == null) return null;
    return RecoveryVideoModel.fromJson(Map<String, dynamic>.from(res));
  }

  Future<RecoveryProgressModel?> getProgressForPlan(String planId) async {
    final res = await _db
        .from('recovery_progress')
        .select()
        .eq('plan_id', planId)
        .maybeSingle();

    if (res == null) return null;
    return RecoveryProgressModel.fromJson(Map<String, dynamic>.from(res));
  }

  Future<void> createProgress(RecoveryProgressModel model) async {
    await _db.from('recovery_progress').insert(model.toJson());
  }

  Future<void> updateProgress(RecoveryProgressModel model) async {
    await _db
        .from('recovery_progress')
        .update(model.toJson())
        .eq('id', model.id);
  }

  Future<void> createTaskCompletion(String planId, String taskId) async {
    await _db.from('recovery_task_completions').insert({
      'plan_id': planId,
      'task_id': taskId,
    });
  }

  Future<List<String>> getCompletedTasks(String planId) async {
    final res = await _db
        .from('recovery_task_completions')
        .select()
        .eq('plan_id', planId);

    return (res as List).map((e) => e['task_id'] as String).toList();
  }

  Future<dynamic> getCompletionsForPlan(String planId) async {}
}
