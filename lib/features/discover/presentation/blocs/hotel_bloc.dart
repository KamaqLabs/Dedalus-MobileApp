import 'package:dedalus/features/discover/data/repositories/hotel_repository.dart';
import 'package:dedalus/features/discover/presentation/blocs/hotel_event.dart';
import 'package:dedalus/features/discover/presentation/blocs/hotel_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final HotelRepository repository;

  HotelBloc({HotelRepository? repository})
      : repository = repository ?? HotelRepository(),
        super(InitialHotelState()) {
    on<GetHotels>(_onGetHotels);
    on<GetHotelById>(_onGetHotelById);
  }

  Future<void> _onGetHotels(GetHotels event, Emitter<HotelState> emit) async {
    emit(LoadingHotelState());
    try {
      final hotels = await repository.getHotels();
      emit(LoadedHotelState(hotels: hotels));
    } on UnsupportedError catch (u) {
      emit(FailureHotelState(errorMessage: u.message ?? 'Listing hotels not available on backend'));
    } catch (e) {
      emit(FailureHotelState(errorMessage: e.toString()));
    }
  }

  Future<void> _onGetHotelById(GetHotelById event, Emitter<HotelState> emit) async {
    emit(LoadingHotelState());
    try {
      final hotel = await repository.getHotel(event.id);
      emit(LoadedHotelState(hotels: [hotel]));
    } catch (e) {
      emit(FailureHotelState(errorMessage: e.toString()));
    }
  }
}
