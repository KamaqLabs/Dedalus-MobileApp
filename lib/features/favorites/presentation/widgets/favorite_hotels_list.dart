import 'package:dedalus/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:dedalus/features/favorites/presentation/blocs/favorite_bloc.dart';
import 'package:dedalus/features/favorites/presentation/blocs/favorite_event.dart';
import 'package:dedalus/features/favorites/presentation/widgets/favorite_hotel_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteHotelsList extends StatelessWidget {
  final List<FavoriteHotel> hotels;

  const FavoriteHotelsList({super.key, required this.hotels});

  @override
  Widget build(BuildContext context) {
    if (hotels.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No favorite hotels yet",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              "Your favorite hotels will appear here",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        final hotel = hotels[index];
        return Dismissible(
          key: Key(hotel.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, color: Colors.white, size: 28),
                SizedBox(height: 4),
                Text(
                  "Remove",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Remove from favorites?"),
                content: const Text("This hotel will be removed from your favorites list."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Remove"),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            context.read<FavoriteBloc>().add(RemoveFavoriteEvent(id: hotel.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${hotel.name} removed from favorites"),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    // Recrear el hotel como favorito usando los campos actuales
                    final favoriteHotel = FavoriteHotel(
                      id: hotel.id,
                      name: hotel.name,
                      ruc: hotel.ruc,
                      address: hotel.address,
                    );
                    context.read<FavoriteBloc>().add(AddFavoriteEvent(favoriteHotel: favoriteHotel));
                  },
                ),
              ),
            );
          },
          child: FavoriteHotelCard(hotel: hotel),
        );
      },
    );
  }
}
