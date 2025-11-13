import 'package:dedalus/features/favorites/data/repositories/favorite_hotel_repository.dart';
import 'package:dedalus/features/favorites/presentation/blocs/favorite_event.dart';
import 'package:dedalus/features/favorites/presentation/blocs/favorite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteHotelRepository _repository;

  // Usa inyección de dependencias para facilitar testing
  FavoriteBloc({required FavoriteHotelRepository repository})
      : _repository = repository,
        super(InitialFavoriteState()) {
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<GetAllFavoriteEvent>(_onGetAllFavorites);
    on<CheckIsFavoriteEvent>(_onCheckIsFavorite);
  }

  // Separa la lógica en métodos privados para mejor organización
  Future<void> _onAddFavorite(
      AddFavoriteEvent event, Emitter<FavoriteState> emit) async {
    emit(LoadingFavoriteState()); // Agrega un estado de carga
    try {
      await _repository.insertFavoriteHotel(event.favoriteHotel);
      final favorites = await _repository.getAllFavoriteHotels();
      emit(LoadedFavoriteState(favorites: favorites));
    } catch (e) {
      emit(ErrorFavoriteState(message: e.toString()));
    }
  }

  Future<void> _onRemoveFavorite(
      RemoveFavoriteEvent event, Emitter<FavoriteState> emit) async {
    emit(LoadingFavoriteState());
    try {
      await _repository.deleteFavoriteHotel(event.id);
      final favorites = await _repository.getAllFavoriteHotels();
      emit(LoadedFavoriteState(favorites: favorites));
    } catch (e) {
      emit(ErrorFavoriteState(message: e.toString()));
    }
  }

  Future<void> _onGetAllFavorites(
      GetAllFavoriteEvent event, Emitter<FavoriteState> emit) async {
    emit(LoadingFavoriteState());
    try {
      final favorites = await _repository.getAllFavoriteHotels();
      emit(LoadedFavoriteState(favorites: favorites));
    } catch (e) {
      emit(ErrorFavoriteState(message: e.toString()));
    }
  }

  // Método para verificar si un hotel es favorito
  Future<void> _onCheckIsFavorite(
      CheckIsFavoriteEvent event, Emitter<FavoriteState> emit) async {
    try {
      final isFavorite = await _repository.isFavorite(event.id);
      emit(IsFavoriteState(isFavorite: isFavorite, id: event.id));
    } catch (e) {
      emit(ErrorFavoriteState(message: e.toString()));
    }
  }
}
