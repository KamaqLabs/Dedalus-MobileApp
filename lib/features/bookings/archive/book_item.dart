class BookItem {
  final String? id;
  final String hotelId;
  final String hotelName;
  final String hotelImage;
  final String location;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int adults;
  final int children;
  final int infants;
  final double pricePerNight;
  final int nights;
  final double taxes;
  final double totalPrice;
  final String paymentMethod;
  final bool isPaid;
  final DateTime bookingDate;
  final double discount;
  String? status;

  BookItem({
    this.id,
    required this.hotelId,
    required this.hotelName,
    required this.hotelImage,
    required this.location,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adults,
    required this.children,
    required this.infants,ants,
    required this.pricePerNight,
    required this.nights,
    required this.taxes,s,
    required this.totalPrice,rice,
    required this.paymentMethod,od,
    required this.isPaid,
    required this.bookingDate,gDate,
    this.discount = 0.0,
    this.status,
  });
}
