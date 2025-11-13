import 'package:flutter/material.dart';
import 'package:dedalus/features/discover/domain/entities/hotel.dart';
import 'package:dedalus/features/discover/presentation/widgets/hotel_card.dart';

class HotelListViewHorizontal extends StatelessWidget {
  final List<Hotel> hotels;
  const HotelListViewHorizontal({super.key, required this.hotels});

  @override
  Widget build(BuildContext context) {
    if (hotels.isEmpty) return const Center(child: Text('No hotels available.'));

    return SizedBox(
      height: 165,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];
          return SizedBox(
            width: 320,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: HotelCard(hotel: hotel),
            ),
          );
        },
      ),
    );
  }
}
