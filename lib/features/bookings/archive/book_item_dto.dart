import 'package:dedalus/features/bookings/archive/book_item.dart';

class BookItemDto {
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

  BookItemDto({
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

  factory BookItemDto.fromJson(Map<String, dynamic> json) {
    return BookItemDto(
      id: json['id']?.toString(),
      hotelId: json['hotelId'],
      userId: json['userId'],
      hotelName: json['hotelName'],
      hotelImage: json['hotelImage'],
      location: json['location'],
      checkInDate: json['checkInDate'],
      checkOutDate: json['checkOutDate'],
      adults: json['adults'],
      children: json['children'],
      infants: json['infants'],
      pricePerNight: json['pricePerNight'],
      nights: json['nights'],
      discount: json['discount'] ?? '0',
      taxes: json['taxes'],
      totalPrice: json['totalPrice'],
      paymentMethod: json['paymentMethod'],
      isPaid: json['isPaid'],
      bookingDate: json['bookingDate'],
      status: json['status'],
    );
  }

  BookItem toDomain() {
    return BookItem(
      id: id,
      hotelId: hotelId,
      hotelName: hotelName,
      hotelImage: hotelImage,
      location: location,
      checkInDate: DateTime.parse(checkInDate),
      checkOutDate: DateTime.parse(checkOutDate),
      adults: int.parse(adults),
      children: int.parse(children),
      infants: int.parse(infants),
      pricePerNight: double.parse(pricePerNight),
      nights: int.parse(nights),
      discount: double.parse(discount),
      taxes: double.parse(taxes),
      totalPrice: double.parse(totalPrice),
      paymentMethod: paymentMethod,
      isPaid: isPaid.toLowerCase() == 'true',
      bookingDate: DateTime.parse(bookingDate),
      status: status,
    );
  }
}
