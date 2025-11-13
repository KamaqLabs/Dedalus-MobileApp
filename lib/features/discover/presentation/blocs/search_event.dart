import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchHotelsEvent extends SearchEvent {
  final String query;
  
  const SearchHotelsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends SearchEvent {}
