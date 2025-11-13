import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/bookings/data/repositories/booking_repository.dart';
import 'package:dedalus/features/bookings/presentation/pages/payment_success_page.dart';
import 'package:dedalus/features/bookings/presentation/pages/add_card_page.dart';
import 'package:dedalus/features/discover/domain/entities/hotel.dart';
import 'package:dedalus/features/discover/domain/entities/room.dart';
import 'package:dedalus/features/auth/data/repositories/user_repository.dart';

class CheckoutPage extends StatefulWidget {
  final Hotel hotel;
  final Room room;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String checkInStr; // yyyy-MM-dd (for API)
  final String checkOutStr; // yyyy-MM-dd (for API)
  final int nights;

  const CheckoutPage({
    super.key,
    required this.hotel,
    required this.room,
    required this.checkInDate,
    required this.checkOutDate,
    required this.checkInStr,
    required this.checkOutStr,
    required this.nights,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final BookingRepository _bookingRepo = BookingRepository();
  final UserRepository _userRepository = UserRepository();

  bool _isProcessing = false;
  String _errorMessage = '';
  String _paymentMethod = 'visa';

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final NumberFormat _currencyFormat = NumberFormat.simpleCurrency(name: '\$');

  double get _pricePerNight => widget.room.roomClass.defaultPricePerNight;
  double get _subtotal => _pricePerNight * widget.nights;
  double get _taxes => (_subtotal * 0.10); // ejemplo: 10% taxes
  double get _total => _subtotal + _taxes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm & Pay'),
        elevation: 0,
      ),
      body: _isProcessing
          ? _buildLoadingView()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel + Room summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Row(
                      children: [
                        // Placeholder image / avatar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade200,
                            child: Center(
                              child: Text(
                                (widget.hotel.name.isNotEmpty ? widget.hotel.name[0] : '?').toUpperCase(),
                                style: const TextStyle(fontSize: 28, color: Colors.black54),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.hotel.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.hotel.address,
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Room: ${widget.room.roomClass.roomClassName}',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${_pricePerNight.toStringAsFixed(2)} / night',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Booking Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),

                        // Dates
                        _buildDetailItem(
                          title: 'Dates',
                          value: "${_dateFormat.format(widget.checkInDate)} - ${_dateFormat.format(widget.checkOutDate)}",
                          icon: Icons.edit,
                          onTap: () => Navigator.pop(context),
                        ),

                        const Divider(),

                        // Guests (showing max occupancy from room class)
                        _buildDetailItem(
                          title: 'Guests',
                          value: 'Max occupancy: ${widget.room.roomClass.maxOccupancy}',
                          icon: Icons.info_outline,
                          onTap: () {}, // no-op (could allow editing locally)
                        ),

                        const SizedBox(height: 24),

                        const Text('Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),

                        // Payment method selector (kept simple)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Pay with', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            TextButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddCardPage()),
                                );
                                if (result != null && result is Map<String, dynamic>) {
                                  setState(() {
                                    _paymentMethod = result['cardType'] ?? _paymentMethod;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Card added'), backgroundColor: Colors.green),
                                  );
                                }
                              },
                              child: Text('Add', style: TextStyle(color: ColorPalette.primaryColor)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Price breakdown
                        const Text('Price Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),
                        _buildPriceRow('${_currencyFormat.format(_pricePerNight)} x ${widget.nights} nights', _currencyFormat.format(_subtotal)),
                        const SizedBox(height: 8),
                        _buildPriceRow('Taxes & fees', _currencyFormat.format(_taxes)),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(_currencyFormat.format(_total), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _isProcessing
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _processBooking,
                child: const Text('Confirm Booking', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
    );
  }

  Widget _buildDetailItem({required String title, required String value, required IconData icon, required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        IconButton(icon: Icon(icon, color: ColorPalette.primaryColor), onPressed: onTap),
      ],
    );
  }

  Widget _buildPriceRow(String left, String right) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(left),
      Text(right),
    ]);
  }

  Widget _buildLoadingView() {
    return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircularProgressIndicator(),
      SizedBox(height: 16),
      Text('Processing your booking...'),
    ]));
  }

  Future<void> _processBooking() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = '';
    });

    try {
      final currentUser = await _userRepository.getCurrentUser();
      if (currentUser == null) throw Exception('User not logged in');

      final created = await _bookingRepo.createBooking(
        hotelId: widget.hotel.id,
        guestId: currentUser.id,
        roomId: widget.room.id,
        checkInDate: widget.checkInStr,
        checkOutDate: widget.checkOutStr,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PaymentSuccessPage(booking: created)),
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking failed: $_errorMessage'), backgroundColor: Colors.red));
    }
  }
}
