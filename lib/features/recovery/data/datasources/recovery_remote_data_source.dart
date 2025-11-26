import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviles252/features/recovery/data/models/recovery_phase_model.dart';
import 'package:moviles252/features/recovery/data/models/recovery_task_model.dart';
import 'package:moviles252/features/recovery/data/models/user_recovery_progress_model.dart';
import 'package:moviles252/features/recovery/data/models/recovery_video_model.dart';
import 'package:moviles252/features/recovery/data/models/injury_evaluation_model.dart';

class RecoveryRemoteDataSource {
  final _db = Supabase.instance.client;

  // get injury evaluation by user (active injury). We'll pick the most recent.
  Future<InjuryEvaluationModel?> getInjuryForUser(String userId) async {
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

  Future<List<RecoveryPhaseModel>> getPhasesByInjury(String injuryId) async {
    final res = await _db
        .from('recovery_phases')
        .select()
        .eq('injury_id', injuryId)
        .order('day_start');
    final list = (res as List)
        .map((e) => RecoveryPhaseModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return list;
  }

  Future<List<RecoveryTaskModel>> getTasksByPhase(String phaseId) async {
    final res = await _db
        .from('recovery_tasks')
        .select()
        .eq('phase_id', phaseId)
        .order('id');
    final list = (res as List)
        .map((e) => RecoveryTaskModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return list;
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

  Future<UserRecoveryProgressModel?> getProgressForUser(
    String userId,
    String injuryId,
  ) async {
    final res = await _db
        .from('user_recovery_progress')
        .select()
        .eq('user_id', userId)
        .eq('injury_id', injuryId)
        .maybeSingle();
    if (res == null) return null;
    return UserRecoveryProgressModel.fromJson(Map<String, dynamic>.from(res));
  }

  Future<void> createProgress(UserRecoveryProgressModel model) async {
    await _db.from('user_recovery_progress').insert(model.toJson());
  }

  Future<void> updateProgress(UserRecoveryProgressModel model) async {
    await _db
        .from('user_recovery_progress')
        .update(model.toJson())
        .eq('id', model.id);
  }
}
