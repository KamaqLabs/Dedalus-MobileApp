import 'package:dedalus/features/discover/domain/entities/hotel.dart';

abstract class HotelState {
  const HotelState();
}

class InitialHotelState extends HotelState {}

class LoadingHotelState extends HotelState {}

class LoadedHotelState extends HotelState {
  final List<Hotel> hotels;
  const LoadedHotelState({required this.hotels});
}

class FailureHotelState extends HotelState {
  final String errorMessage;
  const FailureHotelState({required this.errorMessage});
}
