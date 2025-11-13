import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/auth/data/repositories/user_repository.dart';
import 'package:dedalus/features/bookings/data/datasources/booking_service.dart';
import 'package:dedalus/features/bookings/domain/entities/booking.dart';
import 'package:dedalus/features/bookings/presentation/pages/booking_detail.dart';
import 'package:dedalus/features/bookings/presentation/widgets/booking_card.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BookingService _bookingService = BookingService();
  final UserRepository _userRepository = UserRepository();
  List<Booking> _bookings = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Obtener usuario actual una única vez
      final currentUser = await _userRepository.getCurrentUser();
      if (currentUser == null) {
        setState(() {
          _errorMessage = 'User not logged in';
        });
        return;
      }

      // Llamar al servicio que existe: getBookingsByGuestId(int)
      final bookingDtos = await _bookingService.getBookingsByGuestId(currentUser.id);
      final bookings = bookingDtos.map((dto) => dto.toDomain()).toList();

      if (!mounted) return;

      setState(() {
        _bookings = bookings;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load bookings: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Filtrar reservas próximas (fecha checkout >= hoy y no canceladas)
  List<Booking> get _upcomingBookings {
    final now = DateTime.now();
    return _bookings.where((booking) =>
        (booking.checkOutDate.isAfter(now) || DateUtils.isSameDay(booking.checkOutDate, now)) &&
        booking.bookStatus != 'CANCELLED').toList();
  }

  // Filtrar reservas pasadas (fecha checkout < hoy o canceladas)
  List<Booking> get _pastBookings {
    final now = DateTime.now();
    return _bookings.where((booking) =>
        (booking.checkOutDate.isBefore(now) && !DateUtils.isSameDay(booking.checkOutDate, now)) ||
        booking.bookStatus == 'CANCELLED').toList();
  }

  // Método para manejar eliminación y actualización de la UI (solo local)
  Future<void> _deleteBooking(Booking booking) async {
    try {
      // Eliminar la reserva de la lista local para feedback inmediato
      setState(() {
        _bookings.removeWhere((item) => item.id == booking.id);
      });

      // Mostrar mensaje con opción para deshacer (UNDO) - esto es local
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Booking #${booking.id} removed"),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                // Restaurar localmente
                setState(() {
                  _bookings.add(booking);
                });
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove booking: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: ColorPalette.primaryColor,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : RefreshIndicator(
                  onRefresh: _loadBookings,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Upcoming bookings tab
                      _buildBookingsList(_upcomingBookings, isUpcoming: true),

                      // Past bookings tab
                      _buildBookingsList(_pastBookings, isUpcoming: false),
                    ],
                  ),
                ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, {required bool isUpcoming}) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.event_available : Icons.history,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming bookings' : 'No past bookings',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUpcoming ? 'Explore hotels to make a new booking' : 'Your booking history will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        // Si es una reserva pasada, permitir deslizar para eliminar
        if (!isUpcoming) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Dismissible(
              key: Key(booking.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(height: 4),
                    Text('Remove', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                // Confirmar la eliminación mediante un diálogo
                return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Remove Booking'),
                      content: const Text('Are you sure you want to remove this booking from your history?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Remove', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                // Eliminar la reserva localmente
                _deleteBooking(booking);
              },
              child: GestureDetector(
                onTap: () {
                  // Navigate to booking detail page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailPage(booking: booking),
                    ),
                  ).then((result) {
                    // Si recibimos true, significa que necesitamos refrescar
                    if (result == true) {
                      _loadBookings();
                    }
                  });
                },
                child: BookingCard(
                  booking: booking,
                  isUpcoming: isUpcoming,
                  onRefresh: _loadBookings,
                ),
              ),
            ),
          );
        } else {
          // Para reservas próximas, mantener la implementación original
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                // Navigate to booking detail page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailPage(booking: booking),
                  ),
                ).then((result) {
                  // Si recibimos true, significa que necesitamos refrescar
                  if (result == true) {
                    _loadBookings();
                  }
                });
              },
              child: BookingCard(
                booking: booking,
                isUpcoming: isUpcoming,
                onRefresh: _loadBookings,
              ),
            ),
          );
        }
      },
    );
  }
}
