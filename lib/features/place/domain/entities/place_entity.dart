class PlaceEntity {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double? rating;
  final bool isOpen;

  PlaceEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.rating = 0,
    required this.isOpen,
  });
}
