import 'package:dedalus/features/bookings/archive/book_item.dart';

class BookItemRequestDto {
  final String? id;
  final String hotelId;
  final String userId;
  final String hotelName;
  final String hotelImage;
  final String location;
  final String checkInDate;
  final String checkOutDate;
  final String adults;
  final String children;
  final String infants;
  final String pricePerNight;
  final String nights;
  final String discount;
  final String taxes;
  final String totalPrice;
  final String paymentMethod;
  final String isPaid;
  final String bookingDate;
  final String status;

  BookItemRequestDto({
    this.id,
    required this.hotelId,
    required this.userId,
    required this.hotelName,
    required this.hotelImage,
    required this.location,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adults,
    required this.children,
    required this.infants,
    required this.pricePerNight,
    required this.nights,
    required this.discount,
    required this.taxes,
    required this.totalPrice,
    required this.paymentMethod,
    required this.isPaid,
    required this.bookingDate,
    required this.status,
  });

  // Convertir a JSON para API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'hotelId': hotelId,
      'userId': userId,
      'hotelName': hotelName,
      'hotelImage': hotelImage,
      'location': location,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'adults': adults,
      'children': children,
      'infants': infants,
      'pricePerNight': pricePerNight,
      'nights': nights,
      'discount': discount,
      'taxes': taxes,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'bookingDate': bookingDate,
      'status': status,
    };
  }

  // Crear desde un BookItem
  factory BookItemRequestDto.fromDomain(BookItem booking, String userId) {
    return BookItemRequestDto(
      id: booking.id,
      hotelId: booking.hotelId,
      userId: userId,
      hotelName: booking.hotelName,
      hotelImage: booking.hotelImage,
      location: booking.location,
      checkInDate: booking.checkInDate.toIso8601String().split('T')[0],
      checkOutDate: booking.checkOutDate.toIso8601String().split('T')[0],
      adults: booking.adults.toString(),
      children: booking.children.toString(),
      infants: booking.infants.toString(),
      pricePerNight: booking.pricePerNight.toString(),
      nights: booking.nights.toString(),
      discount: '0', // Valor por defecto si no existe
      taxes: booking.taxes.toString(),
      totalPrice: booking.totalPrice.toString(),
      paymentMethod: booking.paymentMethod,
      isPaid: booking.isPaid.toString(),
      bookingDate: booking.bookingDate.toIso8601String(),
      status: "confirmed",
    );
  }
}
