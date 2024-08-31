import '../../domain/entities/place_entity.dart';

class PlaceModel extends PlaceEntity {
  PlaceModel({
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
    required super.rating,
    required super.isOpen,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['place_id'],
      name: json['name'],
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
      rating: json['rating']?.toDouble(),
      isOpen: json['opening_hours']?['open_now'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'isOpen': isOpen,
    };
  }
}
