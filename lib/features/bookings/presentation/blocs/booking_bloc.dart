import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import 'package:dedalus/features/bookings/data/repositories/booking_repository.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;
  BookingBloc({required this.repository}) : super(BookingInitial()) {
    on<CreateBookingEvent>(_onCreate);
  }

  Future<void> _onCreate(CreateBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final booking = await repository.createBooking(
        hotelId: event.hotelId,
        guestId: event.guestId,
        roomId: event.roomId,
        checkInDate: event.checkInDate,
        checkOutDate: event.checkOutDate,
      );
      emit(BookingSuccess(booking));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }
}
