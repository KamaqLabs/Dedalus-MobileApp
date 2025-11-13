class RoomClass {
  final int id;
  final String roomClassName;
  final int maxOccupancy;
  final double defaultPricePerNight;
  final String? description;

  const RoomClass({
    required this.id,
    required this.roomClassName,
    required this.maxOccupancy,
    required this.defaultPricePerNight,
    this.description,
  });
}
