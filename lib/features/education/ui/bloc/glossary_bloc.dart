import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/glossary_term.dart';
import '../../domain/usecases/view_glossary_flow_usecase.dart';

// Events
abstract class GlossaryEvent {}

class LoadGlossary extends GlossaryEvent {
  final String? searchTerm;

  LoadGlossary({this.searchTerm});
}

class SearchGlossary extends GlossaryEvent {
  final String searchTerm;

  SearchGlossary({required this.searchTerm});
}

class ClearGlossarySearch extends GlossaryEvent {}

// States
abstract class GlossaryState {}

class GlossaryIdle extends GlossaryState {}

class GlossaryLoading extends GlossaryState {}

class GlossaryLoaded extends GlossaryState {
  final List<GlossaryTerm> terms;
  final String? searchTerm;

  GlossaryLoaded(this.terms, {this.searchTerm});
}

class GlossaryError extends GlossaryState {
  final String message;

  GlossaryError(this.message);
}

// BLoC
class GlossaryBloc extends Bloc<GlossaryEvent, GlossaryState> {
  final ViewGlossaryFlowUseCase useCase;

  GlossaryBloc({required this.useCase}) : super(GlossaryIdle()) {
    on<LoadGlossary>(_onLoadGlossary);
    on<SearchGlossary>(_onSearchGlossary);
    on<ClearGlossarySearch>(_onClearSearch);
  }

  Future<void> _onLoadGlossary(
    LoadGlossary event,
    Emitter<GlossaryState> emit,
  ) async {
    emit(GlossaryLoading());
    try {
      final terms = await useCase.execute(event.searchTerm);
      emit(GlossaryLoaded(terms, searchTerm: event.searchTerm));
    } catch (e) {
      emit(GlossaryError(e.toString()));
    }
  }

  Future<void> _onSearchGlossary(
    SearchGlossary event,
    Emitter<GlossaryState> emit,
  ) async {
    emit(GlossaryLoading());
    try {
      final terms = await useCase.execute(event.searchTerm);
      emit(GlossaryLoaded(terms, searchTerm: event.searchTerm));
    } catch (e) {
      emit(GlossaryError(e.toString()));
    }
  }

  Future<void> _onClearSearch(
    ClearGlossarySearch event,
    Emitter<GlossaryState> emit,
  ) async {
    emit(GlossaryLoading());
    try {
      final terms = await useCase.execute(null);
      emit(GlossaryLoaded(terms));
    } catch (e) {
      emit(GlossaryError(e.toString()));
    }
  }
}
