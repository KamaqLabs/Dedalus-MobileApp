import 'package:dedalus/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
  
  @override
  List<Object?> get props => [];
}

class InitialFavoriteState extends FavoriteState {}

class LoadingFavoriteState extends FavoriteState {}

class LoadedFavoriteState extends FavoriteState {
  final List<FavoriteHotel> favorites;
  
  const LoadedFavoriteState({required this.favorites});
  
  @override
  List<Object?> get props => [favorites];
}

class ErrorFavoriteState extends FavoriteState {
  final String message;
  
  const ErrorFavoriteState({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class IsFavoriteState extends FavoriteState {
  final bool isFavorite;
  final int id; 
  
  const IsFavoriteState({required this.isFavorite, required this.id});
  
  @override
  List<Object?> get props => [isFavorite, id];
}
