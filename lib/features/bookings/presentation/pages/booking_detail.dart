import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dedalus/features/bookings/domain/entities/booking.dart';
import 'package:dedalus/features/discover/data/repositories/hotel_repository.dart';
import 'package:dedalus/features/discover/domain/entities/hotel.dart';

class BookingDetailPage extends StatefulWidget {
  final Booking booking;

  const BookingDetailPage({
    super.key,
    required this.booking,
  });

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  bool _loadingHotel = true;
  String? _hotelError;
  Hotel? _hotel;

  @override
  void initState() {
    super.initState();
    _loadHotel();
  }

  Future<void> _loadHotel() async {
    setState(() {
      _loadingHotel = true;
      _hotelError = null;
    });

    try {
      final repo = HotelRepository();
      final h = await repo.getHotel(widget.booking.hotelId);
      if (mounted) {
        setState(() {
          _hotel = h;
          _loadingHotel = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hotelError = 'Error loading hotel';
          _loadingHotel = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final dateFormat = DateFormat('MMM dd, yyyy');
    final currency = NumberFormat.simpleCurrency(name: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        elevation: 0,
        actions: [
          if (_loadingHotel)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadHotel,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel header (minimal)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.06), blurRadius: 8)],
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        (_hotel?.name ?? 'H${booking.hotelId}').isNotEmpty
                            ? (_hotel?.name ?? 'H${booking.hotelId}')[0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontSize: 28, color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _hotel?.name ?? 'Hotel #${booking.hotelId}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _hotel?.address ?? '',
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Status: ${booking.bookStatus}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_hotelError != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 4.0, right: 4.0),
                child: Material(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(8),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.error_outline, color: Colors.orange),
                    title: Text(_hotelError!, style: const TextStyle(color: Colors.black87)),
                    trailing: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _loadHotel,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Booking information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.06), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Booking Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _detailRow('Booking ID', '#${booking.id}'),
                  const Divider(),
                  _detailRow('Room ID', '${booking.roomId}'),
                  const SizedBox(height: 8),
                  _detailRow('Check-in', dateFormat.format(booking.checkInDate)),
                  const SizedBox(height: 8),
                  _detailRow('Check-out', dateFormat.format(booking.checkOutDate)),
                  const SizedBox(height: 8),
                  _detailRow('Nights', '${booking.durationInDays}'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Price summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.06), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _detailRow('Total', currency.format(booking.totalPrice)),
                  const SizedBox(height: 8),
                  _detailRow('Created at', booking.createdAt != null ? dateFormat.format(booking.createdAt!) : '-'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Guest info (if available)
            if (booking.guest != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.06), blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Guest', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _detailRow('Name', '${booking.guest!.name} ${booking.guest!.lastName}'),
                    const SizedBox(height: 8),
                    _detailRow('DNI', booking.guest!.dni),
                    const SizedBox(height: 8),
                    _detailRow('Email', booking.guest!.email),
                    const SizedBox(height: 8),
                    _detailRow('Phone', booking.guest!.phoneNumber),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
