import '../entities/place_entity.dart';
import '../repositories/place_repository.dart';

class ManageFavorites {
  final PlaceRepository repository;

  ManageFavorites(this.repository);

  Future<void> addFavorite(PlaceEntity place) async {
    try {
      await repository.saveFavoritePlace(place);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFavorite(String placeId) async {
    try {
      await repository.removeFavoritePlace(placeId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PlaceEntity>> getFavorites() async {
    try {
      return await repository.getFavoritePlaces();
    } catch (e) {
      rethrow;
    }
  }
}
