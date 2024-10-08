import '../entities/place_entity.dart';

abstract class PlaceRepository {
  Future<List<PlaceEntity>> getNearbyPlaces(
      double latitude, double longitude, String searchType);
  Future<void> saveFavoritePlace(PlaceEntity place);
  Future<void> removeFavoritePlace(String placeId);
  Future<List<PlaceEntity>> getFavoritePlaces();
}
