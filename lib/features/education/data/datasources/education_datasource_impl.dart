import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/injury_education_model.dart';
import '../models/prevention_tip_model.dart';
import '../models/myth_model.dart';
import '../models/glossary_term_model.dart';
import 'education_datasource.dart';
import 'mock_education_data.dart';

class EducationDataSourceImpl implements EducationDataSource {
  final SupabaseClient supabaseClient;
  final bool useMockData;

  EducationDataSourceImpl({
    required this.supabaseClient,
    this.useMockData = false,
  });

  @override
  Future<List<InjuryEducationModel>> getCommonInjuries(
    String? bodyLocation,
  ) async {
    try {
      if (useMockData) {
        var data = mockInjuryEducations;
        if (bodyLocation != null) {
          data = data
              .where((e) => e['body_location'] == bodyLocation)
              .toList();
        }
        return data
            .map((e) => InjuryEducationModel.fromJson(
                Map<String, dynamic>.from(e)))
            .toList();
      }

      // Supabase query
      var query = supabaseClient.from('injury_educations').select();
      if (bodyLocation != null) {
        query = query.eq('body_location', bodyLocation);
      }

      final response = await query;
      return (response as List)
          .map((e) => InjuryEducationModel.fromJson(
              Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener lesiones comunes: $e');
    }
  }

  @override
  Future<List<PreventionTipModel>> getPreventionTips(
    String? sport,
  ) async {
    try {
      if (useMockData) {
        var data = mockPreventionTips;
        if (sport != null) {
          data = data.where((e) => e['sport'] == sport).toList();
        }
        return data
            .map((e) => PreventionTipModel.fromJson(
                Map<String, dynamic>.from(e)))
            .toList();
      }

      // Supabase query
      var query = supabaseClient.from('prevention_tips').select();
      if (sport != null) {
        query = query.eq('sport', sport);
      }

      final response = await query;
      return (response as List)
          .map((e) => PreventionTipModel.fromJson(
              Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener tips de prevención: $e');
    }
  }

  @override
  Future<List<MythModel>> getMyths() async {
    try {
      if (useMockData) {
        return mockMyths
            .map((e) => MythModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      // Supabase query
      final response = await supabaseClient.from('myths').select();
      return (response as List)
          .map((e) => MythModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener mitos: $e');
    }
  }

  @override
  Future<List<GlossaryTermModel>> getGlossary(String? searchTerm) async {
    try {
      if (useMockData) {
        var data = mockGlossaryTerms;
        if (searchTerm != null && searchTerm.isNotEmpty) {
          final lowerSearchTerm = searchTerm.toLowerCase();
          data = data
              .where((e) =>
                  e['term']
                      .toString()
                      .toLowerCase()
                      .contains(lowerSearchTerm) ||
                  e['definition']
                      .toString()
                      .toLowerCase()
                      .contains(lowerSearchTerm))
              .toList();
        }
        return data
            .map((e) => GlossaryTermModel.fromJson(
                Map<String, dynamic>.from(e)))
            .toList();
      }

      // Supabase query
      final response =
          await supabaseClient.from('glossary_terms').select();
      var terms = (response as List)
          .map((e) => GlossaryTermModel.fromJson(
              Map<String, dynamic>.from(e)))
          .toList();

      // Client-side filtering for search
      if (searchTerm != null && searchTerm.isNotEmpty) {
        final lowerSearchTerm = searchTerm.toLowerCase();
        terms = terms
            .where((e) =>
                e.term.toLowerCase().contains(lowerSearchTerm) ||
                e.definition.toLowerCase().contains(lowerSearchTerm))
            .toList();
      }

      return terms;
    } catch (e) {
      throw Exception('Error al obtener glosario: $e');
    }
  }
}
