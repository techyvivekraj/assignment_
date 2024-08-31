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

  @override
  void onInit() {
    fetchCurrentLocationAndNearbyPlaces();
    // TODO: implement onInit
    super.onInit();
  }

  void fetchCurrentLocationAndNearbyPlaces() async {
    try {
      await fetchNearbyPlaces();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchNearbyPlaces() async {
    try {
      final location = await LocationUtils.getCurrentLocation();
      currentLocation.value = location;
      final places =
          await getNearbyPlaces(location.latitude, location.longitude);
      print("vivek $places");
      nearbyPlaces.assignAll(places);
    } catch (e) {
      print("vivek $e");
    }
  }

  void toggleFavoritePlace(PlaceEntity place) async {
    if (favoritePlaces.any((p) => p.id == place.id)) {
      await manageFavorites.removeFavorite(place.id);
      favoritePlaces.removeWhere((p) => p.id == place.id);
    } else {
      await manageFavorites.addFavorite(place);
      favoritePlaces.add(place);
    }
  }
}
