import 'package:dedalus/features/discover/domain/entities/hotel.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class InitialSearchState extends SearchState {}

class LoadingSearchState extends SearchState {}

class LoadedSearchState extends SearchState {
  final List<Hotel> hotels;
  final String query;
  
  const LoadedSearchState({
    required this.hotels,
    required this.query,
  });

  @override
  List<Object?> get props => [hotels, query];
}

class NoResultsSearchState extends SearchState {
  final String query;
  
  const NoResultsSearchState({required this.query});

  @override
  List<Object?> get props => [query];
}

class ErrorSearchState extends SearchState {
  final String message;
  
  const ErrorSearchState({required this.message});

  @override
  List<Object?> get props => [message];
}
