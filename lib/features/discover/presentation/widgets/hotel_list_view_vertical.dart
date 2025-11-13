import 'package:flutter/material.dart';
import 'package:dedalus/features/discover/domain/entities/hotel.dart';
import 'package:dedalus/features/discover/presentation/widgets/hotel_card.dart';

class HotelListViewVertical extends StatelessWidget {
  final List<Hotel> hotels;
  const HotelListViewVertical({super.key, required this.hotels});

  @override
  Widget build(BuildContext context) {
    if (hotels.isEmpty) return const Center(child: Text('No hotels available.'));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        final hotel = hotels[index];
        return HotelCard(hotel: hotel);
      },
    );
  }
}
