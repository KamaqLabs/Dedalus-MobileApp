abstract class HotelEvent {
  const HotelEvent();
}

class GetHotels extends HotelEvent {}

//Obtener un hotel por id
class GetHotelById extends HotelEvent {
  final int id;
  const GetHotelById({required this.id});
}
