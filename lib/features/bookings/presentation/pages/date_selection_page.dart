import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/discover/domain/entities/hotel.dart';
import 'package:dedalus/features/discover/domain/entities/room.dart';
import 'package:dedalus/features/discover/data/repositories/hotel_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dedalus/features/bookings/presentation/pages/checkout_page.dart';

class DateSelectionPage extends StatefulWidget {
  final Room room;
  
  const DateSelectionPage({super.key, required this.room});

  @override
  State<DateSelectionPage> createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends State<DateSelectionPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  Hotel? _hotel;
  bool _loadingHotel = true;
  String? _hotelError;
  
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
      final h = await repo.getHotel(widget.room.hotelId);
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
    final room = widget.room;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Date'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Room / Hotel info card
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
            child: Row(
              children: [
                // Placeholder image (no hotel images in domain by default)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Text(
                        ( _hotel?.name ?? 'H${room.hotelId}' ).isNotEmpty ? ( _hotel?.name ?? 'H${room.hotelId}' )[0].toUpperCase() : '?',
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
                        _hotel?.name ?? 'Hotel #${room.hotelId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Room: ${room.roomNumber.isNotEmpty ? room.roomNumber : room.roomClass.roomClassName}',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${room.roomClass.defaultPricePerNight.toStringAsFixed(2)} / night',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (_loadingHotel)
                  const SizedBox(width: 24, child: CircularProgressIndicator())
                else if (_hotelError != null)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadHotel,
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Dates selection summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildDateCard(
                    "Check-in",
                    _selectedStartDate != null
                        ? _dateFormat.format(_selectedStartDate!)
                        : "Select date",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateCard(
                    "Check-out",
                    _selectedEndDate != null
                        ? _dateFormat.format(_selectedEndDate!)
                        : "Select date",
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Calendar
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return _isSelectedDay(day);
            },
            rangeStartDay: _selectedStartDate,
            rangeEndDay: _selectedEndDate,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: ColorPalette.primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: ColorPalette.primaryColor,
                shape: BoxShape.circle,
              ),
              rangeStartDecoration: BoxDecoration(
                color: ColorPalette.primaryColor,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: BoxDecoration(
                color: ColorPalette.primaryColor,
                shape: BoxShape.circle,
              ),
              rangeHighlightColor: ColorPalette.primaryColor.withOpacity(0.1),
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: ColorPalette.primaryColor),
              rightChevronIcon: Icon(Icons.chevron_right, color: ColorPalette.primaryColor),
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
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
          onPressed: _canProceed() ? () {
            _proceedToGuestSelection();
          } : null,
          child: const Text(
            "Continue",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard(String title, String date) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  bool _isSelectedDay(DateTime day) {
    if (_selectedStartDate == null && _selectedEndDate == null) {
      return false;
    }
    
    if (_selectedEndDate == null) {
      return isSameDay(_selectedStartDate!, day);
    }
    
    return isSameDay(_selectedStartDate!, day) || 
           isSameDay(_selectedEndDate!, day) || 
           (day.isAfter(_selectedStartDate!) && day.isBefore(_selectedEndDate!));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedStartDate == null || _selectedEndDate != null) {
        // Primer click o reinicio de selección
        _selectedStartDate = selectedDay;
        _selectedEndDate = null;
      } else {
        // Segundo click - seleccionar fecha fin
        if (selectedDay.isBefore(_selectedStartDate!)) {
          // Si la fecha seleccionada es anterior, intercambiar
          _selectedEndDate = _selectedStartDate;
          _selectedStartDate = selectedDay;
        } else {
          _selectedEndDate = selectedDay;
        }
      }
    });
  }

  bool _canProceed() {
    return _selectedStartDate != null && _selectedEndDate != null;
  }

  void _proceedToGuestSelection() {
    final int nights = _selectedEndDate!.difference(_selectedStartDate!).inDays;
    final checkInStr = DateFormat('yyyy-MM-dd').format(_selectedStartDate!);
    final checkOutStr = DateFormat('yyyy-MM-dd').format(_selectedEndDate!);

    final hotelToPass = _hotel ??
        Hotel(
          id: widget.room.hotelId,
          name: 'Hotel #${widget.room.hotelId}',
          ruc: '',
          address: '',
        );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          hotel: hotelToPass,
          room: widget.room,
          checkInDate: _selectedStartDate!,
          checkOutDate: _selectedEndDate!,
          checkInStr: checkInStr,     // yyyy-MM-dd for API
          checkOutStr: checkOutStr,   // yyyy-MM-dd for API
          nights: nights,
        ),
      ),
    );
  }
}
