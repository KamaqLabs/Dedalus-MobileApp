import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/bookings/presentation/pages/date_selection_page.dart';
import 'package:dedalus/features/discover/data/repositories/hotel_repository.dart';
import 'package:dedalus/features/discover/data/repositories/room_repository.dart';
import 'package:dedalus/features/discover/domain/entities/hotel.dart';
import 'package:dedalus/features/discover/domain/entities/room.dart';
import 'package:dedalus/features/favorites/data/repositories/favorite_hotel_repository.dart';
import 'package:dedalus/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:flutter/material.dart';

class HotelDetailPage extends StatefulWidget {
  final int hotelId;

  const HotelDetailPage({
    super.key,
    required this.hotelId,
  });

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  bool _isLoading = true;
  Hotel? _hotel;
  String? _errorMessage;

  List<Room> _rooms = [];
  Room? _selectedRoom;

  final FavoriteHotelRepository _favRepo = FavoriteHotelRepository();

  // estado local para el icono de favoritos (por defecto false)
  bool _isFavorite = false;

  void _toggleFavorite() async {
    if (_hotel == null) return;

    try {
      if (!_isFavorite) {
        final fav = FavoriteHotel(
          id: _hotel!.id,
          name: _hotel!.name,
          ruc: _hotel!.ruc,
          address: _hotel!.address,
        );
        await _favRepo.insertFavoriteHotel(fav);
      } else {
        await _favRepo.deleteFavoriteHotel(_hotel!.id);
      }

      setState(() {
        _isFavorite = !_isFavorite;
      });

      final msg = _isFavorite ? 'Added to favorites' : 'Removed from favorites';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Favorites error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final hotelRepo = HotelRepository();
      final roomRepo = RoomRepository();

      final hotel = await hotelRepo.getHotel(widget.hotelId);
      final rooms = await roomRepo.getRoomsByHotel(widget.hotelId);

      bool isFav = false;
      if (hotel != null) {
        isFav = await _favRepo.isFavorite(hotel.id);
      }

      if (mounted) {
        setState(() {
          _hotel = hotel;
          _rooms = rooms;
          _selectedRoom = rooms.isNotEmpty ? rooms.first : null;
          _isFavorite = isFav;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading hotel data: $e';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildRoomTile(Room room) {
    final price = room.roomClass.defaultPricePerNight;
    final subtitle = [
      'Room ${room.roomNumber}',
      if (room.floor != null) 'Floor ${room.floor}',
      'Status: ${room.roomStatus}',
      'Max: ${room.roomClass.maxOccupancy}',
    ].join(' • ');

    final selected = _selectedRoom?.id == room.id;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: selected ? ColorPalette.primaryColor.withOpacity(0.08) : null,
      child: RadioListTile<int>(
        value: room.id,
        groupValue: _selectedRoom?.id,
        onChanged: (v) {
          setState(() {
            _selectedRoom = room;
          });
        },
        title: Text(room.roomClass.roomClassName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        secondary: Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading ? const Text('Loading...') : Text(_hotel?.name ?? 'Hotel'),
        actions: [
          IconButton(
            tooltip: 'Add to favorites',
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? Colors.redAccent : null),
            onPressed: _isLoading ? null : _toggleFavorite,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      ElevatedButton(onPressed: _loadData, child: const Text('Try Again')),
                    ],
                  ),
                )
              : _hotel == null
                  ? const Center(child: Text('Hotel not found'))
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Basic hotel header
                              Container(
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_hotel!.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(_hotel!.address, style: const TextStyle(color: Colors.grey)),
                                    const SizedBox(height: 6),
                                    Text('RUC: ${_hotel!.ruc}', style: const TextStyle(color: Colors.black54)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: const Text('Available rooms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),

                        // Rooms list
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          sliver: _rooms.isEmpty
                              ? SliverToBoxAdapter(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                                      child: Text('No rooms available for this hotel.'),
                                    ),
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final room = _rooms[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: _buildRoomTile(room),
                                      );
                                    },
                                    childCount: _rooms.length,
                                  ),
                                ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 96)),
                      ],
                    ),
      bottomNavigationBar: _isLoading || _errorMessage != null || _hotel == null || _selectedRoom == null
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$${_selectedRoom!.roomClass.defaultPricePerNight.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                        ),
                        const TextSpan(text: ' /night', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      // Navegar a la selección de fecha pasando la Room seleccionada
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DateSelectionPage(room: _selectedRoom!),
                        ),
                      );
                    },
                    child: const Text('Select Date', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
    );
  }
}
