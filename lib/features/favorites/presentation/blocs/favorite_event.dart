import 'package:dedalus/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  
  @override
  List<Object?> get props => [];
}

class AddFavoriteEvent extends FavoriteEvent {
  final FavoriteHotel favoriteHotel;
  
  const AddFavoriteEvent({required this.favoriteHotel});
  
  @override
  List<Object?> get props => [favoriteHotel];
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final int id;
  
  const RemoveFavoriteEvent({required this.id});
  
  @override
  List<Object?> get props => [id];
}

class GetAllFavoriteEvent extends FavoriteEvent {}

class CheckIsFavoriteEvent extends FavoriteEvent {
  final int id;
  
  const CheckIsFavoriteEvent({required this.id});
  
  @override
  List<Object?> get props => [id];
}

