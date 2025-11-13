import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/discover/data/repositories/hotel_repository.dart';
import 'package:dedalus/features/discover/presentation/pages/hotel_detail_page.dart';
import 'package:dedalus/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:dedalus/features/favorites/presentation/blocs/favorite_bloc.dart';
import 'package:dedalus/features/favorites/presentation/blocs/favorite_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteHotelCard extends StatefulWidget {
  const FavoriteHotelCard({super.key, required this.hotel});
  final FavoriteHotel hotel;

  @override
  State<FavoriteHotelCard> createState() => _FavoriteHotelCardState();
}

class _FavoriteHotelCardState extends State<FavoriteHotelCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Loading ${widget.hotel.name} details...'),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Placeholder avatar (no image in API)
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                widget.hotel.name.isNotEmpty ? widget.hotel.name[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 20, color: Colors.black87),
              ),
            ),
            const SizedBox(width: 16),
            // Información del hotel
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.hotel.address,
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RUC: ${widget.hotel.ruc}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            // Botón de reserva
            Tooltip(
              message: 'View details',
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: _navigateToHotelDetail,
                child: const Text('Details', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToHotelDetail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final hotelRepository = HotelRepository();
      final completeHotel = await hotelRepository.getHotel(widget.hotel.id);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HotelDetailPage(hotelId: completeHotel.id),
        ),
      );

      if (mounted) {
        context.read<FavoriteBloc>().add(GetAllFavoriteEvent());
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading hotel details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
