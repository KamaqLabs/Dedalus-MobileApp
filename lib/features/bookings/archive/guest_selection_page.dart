/**
 * import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/bookings/presentation/pages/checkout_page.dart';
import 'package:dedalus/features/discover/domain/entities/hotel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GuestSelectionPage extends StatefulWidget {
  final Hotel hotel;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int nights;
  
  const GuestSelectionPage({
    super.key, 
    required this.hotel,
    required this.checkInDate,
    required this.checkOutDate,
    required this.nights,
  });

  @override
  State<GuestSelectionPage> createState() => _GuestSelectionPageState();
}

class _GuestSelectionPageState extends State<GuestSelectionPage> {
  int _adults = 2;
  int _children = 0;
  int _infants = 0;
  
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Guests'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Hotel info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.hotel.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.hotel.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "${widget.hotel.city}, ${widget.hotel.country}",
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                "${widget.hotel.rating} (${widget.hotel.reviews.length} Reviews)",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check-in',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _dateFormat.format(widget.checkInDate),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward, color: Colors.grey),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Check-out',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _dateFormat.format(widget.checkOutDate),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Guest selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Guest',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Adults
                _buildGuestSelector(
                  title: 'Adults',
                  subtitle: 'Ages 14 or above',
                  value: _adults,
                  onDecrease: () {
                    if (_adults > 1) {
                      setState(() {
                        _adults--;
                      });
                    }
                  },
                  onIncrease: () {
                    if (_adults < 10) {
                      setState(() {
                        _adults++;
                      });
                    }
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Children
                _buildGuestSelector(
                  title: 'Children',
                  subtitle: 'Ages 2-13',
                  value: _children,
                  onDecrease: () {
                    if (_children > 0) {
                      setState(() {
                        _children--;
                      });
                    }
                  },
                  onIncrease: () {
                    if (_children < 6) {
                      setState(() {
                        _children++;
                      });
                    }
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Infants
                _buildGuestSelector(
                  title: 'Infants',
                  subtitle: 'Under 2',
                  value: _infants,
                  onDecrease: () {
                    if (_infants > 0) {
                      setState(() {
                        _infants--;
                      });
                    }
                  },
                  onIncrease: () {
                    if (_infants < 2) {
                      setState(() {
                        _infants++;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () {
            _proceedToCheckout();
          },
          child: const Text(
            "Next",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildGuestSelector({
    required String title,
    required String subtitle,
    required int value,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Decrease button
            _buildCircularButton(
              icon: Icons.remove,
              onTap: onDecrease,
            ),
            
            // Value
            SizedBox(
              width: 40,
              child: Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            
            // Increase button
            _buildCircularButton(
              icon: Icons.add,
              onTap: onIncrease,
              primary: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
    bool primary = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primary ? ColorPalette.primaryColor : Colors.white,
          border: primary ? null : Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 16,
            color: primary ? Colors.white : ColorPalette.primaryColor,
          ),
        ),
      ),
    );
  }

  void _proceedToCheckout() {
    // Calcular el precio total basado en el precio por noche y el número de noches
    final double subtotal = widget.hotel.pricePerNight.toDouble() * widget.nights;
    final double taxes = subtotal * 0.1;  // 10% de impuestos
    final double total = subtotal + taxes;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          hotel: widget.hotel,
          checkInDate: widget.checkInDate,
          checkOutDate: widget.checkOutDate,
          nights: widget.nights,
          adults: _adults,
          children: _children,
          infants: _infants,
          subtotal: subtotal,
          taxes: taxes,
          total: total,
        ),
      ),
    );
  }
}
 */
