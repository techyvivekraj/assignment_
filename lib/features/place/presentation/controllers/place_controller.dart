import 'package:assignment/core/errors/exceptions.dart';
import 'package:assignment/core/utils/location_utils.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
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
    try {
      isLoading(true);
      fetchNearbyPlaces();
      fetchavoritesPlaces();
    } on PermissionDeniedException {
      throw LocationPermissionDeniedException();
    } catch (e) {
      isLoading(false);
      handleErrors(e);
    }
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> fetchNearbyPlaces() async {
    try {
      final location = await LocationUtils.getCurrentLocation();
      currentLocation.value = location;
      final places =
          await getNearbyPlaces(location.latitude, location.longitude);
      nearbyPlaces.assignAll(places);
    } on PermissionDeniedException {
      throw LocationPermissionDeniedException();
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

  void handleErrors(dynamic e) {
    if (e is LocationPermissionDeniedException) {
      errorMessage(
          'Location permission was denied. Please enable it in the settings.');
    } else if (e is NoNearbyPlacesFoundException) {
      errorMessage('No nearby places found.');
    } else if (e is ApiException) {
      errorMessage(
          'Failed to load data from the server. Please check your connection and try again.');
    } else {
      errorMessage('Something went wrong. Please try again later.');
    }
  }
}
