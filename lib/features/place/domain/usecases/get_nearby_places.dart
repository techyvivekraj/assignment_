import '../entities/place_entity.dart';
import '../repositories/place_repository.dart';

class GetNearbyPlaces {
  final PlaceRepository repository;

  GetNearbyPlaces(this.repository);

  Future<List<PlaceEntity>> call(double latitude, double longitude) async {
    return await repository.getNearbyPlaces(latitude, longitude);
  }
}
