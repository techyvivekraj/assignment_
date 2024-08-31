import 'package:assignment/core/utils/location_utils.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/usecases/get_nearby_places.dart';
import '../../domain/usecases/manage_favorites.dart';

class PlaceController extends GetxController {
  final GetNearbyPlaces getNearbyPlaces;
  final ManageFavorites manageFavorites;

  PlaceController({
    required this.getNearbyPlaces,
    required this.manageFavorites,
  });

  var currentLocation = Rxn<Position>();
  var nearbyPlaces = <PlaceEntity>[].obs;
  var favoritePlaces = <PlaceEntity>[].obs;

  var errorMessage = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchPlace();
    super.onInit();
  }

  void fetchPlace() async {
    try {
      isLoading(true);
      errorMessage('');
      await fetchNearbyPlaces();
      await fetchavoritesPlaces();
    } on PermissionDeniedException {
      errorMessage('Permission denied');
    } on ClientException {
      errorMessage('Network issue found');
    } catch (e) {
      errorMessage('Something went wrong');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchNearbyPlaces() async {
    try {
      final location = await LocationUtils.getCurrentLocation();
      currentLocation.value = location;
      final places =
          await getNearbyPlaces(location.latitude, location.longitude);
      nearbyPlaces.assignAll(places);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchavoritesPlaces() async {
    try {
      final favoritePlace = await manageFavorites.getFavorites();
      favoritePlaces.assignAll(favoritePlace);
    } catch (e) {
      rethrow;
    }
  }

  void toggleFavoritePlace(PlaceEntity place) async {
    try {
      if (favoritePlaces.any((p) => p.id == place.id)) {
        await manageFavorites.removeFavorite(place.id);
        favoritePlaces.removeWhere((p) => p.id == place.id);
      } else {
        await manageFavorites.addFavorite(place);
        favoritePlaces.add(place);
      }
    } catch (e) {
      errorMessage("Something went wrong");
    }
  }
}
