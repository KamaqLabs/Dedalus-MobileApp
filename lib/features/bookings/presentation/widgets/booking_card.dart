import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/bookings/domain/entities/booking.dart';
import 'package:dedalus/features/discover/domain/entities/room.dart';
import 'package:dedalus/features/discover/domain/entities/room_class.dart';
import 'package:dedalus/features/discover/presentation/pages/hotel_detail_page.dart';
import 'package:dedalus/features/bookings/presentation/pages/date_selection_page.dart';
import 'package:dedalus/features/bookings/presentation/pages/booking_detail.dart';

class BookingCard extends StatefulWidget {
  final Booking booking;
  final bool isUpcoming; 
  final String? hotelName; 
  final String? hotelImage;
  final String? location;
  final VoidCallback? onRefresh;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isUpcoming, 
    this.hotelName,
    this.hotelImage,
    this.location,
    this.onRefresh,
  });

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  bool _isNavigating = false;

  String _formatDate(DateTime d) => DateFormat.yMMMd().format(d);

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final title = widget.hotelName ?? 'Hotel #${b.hotelId}';
    final subtitle = widget.location ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: hotel name + optional location
            Row(
              children: [
                // Placeholder image
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    image: widget.hotelImage != null && widget.hotelImage!.isNotEmpty
                        ? DecorationImage(image: NetworkImage(widget.hotelImage!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: widget.hotelImage == null || widget.hotelImage!.isEmpty
                      ? Center(
                          child: Text(
                            title.isNotEmpty ? title[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 24, color: Colors.black54),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(subtitle, style: const TextStyle(color: Colors.grey)),
                      ],
                    ],
                  ),
                ),
                // Status / price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(b.bookStatus, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('\$${b.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Dates row
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text('${_formatDate(b.checkInDate)} — ${_formatDate(b.checkOutDate)}', style: const TextStyle(color: Colors.black87)),
                const Spacer(),
                Text('${b.durationInDays} nights', style: const TextStyle(color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 12),

            // Actions
            Row(
              children: [
                OutlinedButton(
                  onPressed: _isNavigating ? null : () => _openDetails(b),
                  child: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isNavigating ? null : () => _bookAgain(b),
                  style: ElevatedButton.styleFrom(backgroundColor: ColorPalette.primaryColor),
                  child: const Text('Book Again', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDetails(Booking b) async {
    setState(() => _isNavigating = true);
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BookingDetailPage(booking: b)),
      );
      widget.onRefresh?.call();
    } finally {
      if (mounted) setState(() => _isNavigating = false);
    }
  }

  Future<void> _bookAgain(Booking b) async {
    setState(() => _isNavigating = true);
    try {
      // Construir Room mínimo usando datos del booking (fallbacks defensivos)
      final room = Room(
        id: b.roomId,
        hotelId: b.hotelId,
        roomNumber: '', // no disponible en Booking DTO; detalle se obtiene en DateSelectionPage if needed
        floor: null,
        nfcKey: null,
        modulesId: const <int>[],
        roomStatus: 'available',
        roomClass: RoomClass(
          id: 0,
          roomClassName: 'Standard',
          maxOccupancy: 1,
          defaultPricePerNight: b.totalPrice,
          description: null,
        ),
      );

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DateSelectionPage(room: room)),
      );
    } catch (e) {
      // Fallback: abrir hotel details if navigation to DateSelectionPage fails
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HotelDetailPage(hotelId: b.hotelId)),
      );
    } finally {
      if (mounted) setState(() => _isNavigating = false);
    }
  }
}
