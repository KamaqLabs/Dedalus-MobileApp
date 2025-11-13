import 'package:dedalus/features/discover/data/repositories/hotel_repository.dart';
import 'package:dedalus/features/discover/presentation/blocs/search_event.dart';
import 'package:dedalus/features/discover/presentation/blocs/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HotelRepository repository;
  
  SearchBloc({required this.repository}) : super(InitialSearchState()) {
    on<SearchHotelsEvent>(_onSearchHotels);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchHotels(
      SearchHotelsEvent event, Emitter<SearchState> emit) async {
    emit(LoadingSearchState());
    
    try {
      final query = event.query.trim();
      
      if (query.isEmpty) {
        emit(InitialSearchState());
        return;
      }

      // Si la query es un entero, tratamos como búsqueda por id usando el endpoint existente.
      final id = int.tryParse(query);
      if (id != null) {
        try {
          final hotel = await repository.getHotel(id);
          emit(LoadedSearchState(hotels: [hotel], query: query));
          return;
        } catch (e) {
          emit(ErrorSearchState(message: e.toString()));
          return;
        }
      }

      // Si no es numérico, usamos el nuevo endpoint GET /Hotel/Hotels y filtramos cliente-side.
      final results = await repository.searchHotels(query);
      
      if (results.isEmpty) {
        emit(NoResultsSearchState(query: query));
      } else {
        emit(LoadedSearchState(hotels: results, query: query));
      }
    } on UnsupportedError catch (u) {
      emit(ErrorSearchState(message: u.message ?? 'Search not available on backend'));
    } catch (e) {
      emit(ErrorSearchState(message: e.toString()));
    }
  }

  Future<void> _onClearSearch(
      ClearSearchEvent event, Emitter<SearchState> emit) async {
    emit(InitialSearchState());
  }
}
