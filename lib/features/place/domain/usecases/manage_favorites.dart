import '../entities/place_entity.dart';
import '../repositories/place_repository.dart';

class ManageFavorites {
  final PlaceRepository repository;

  ManageFavorites(this.repository);

  Future<void> addFavorite(PlaceEntity place) async {
    await repository.saveFavoritePlace(place);
  }

  Future<void> removeFavorite(String placeId) async {
    await repository.removeFavoritePlace(placeId);
  }

  Future<List<PlaceEntity>> getFavorites() async {
    return await repository.getFavoritePlaces();
  }
}
