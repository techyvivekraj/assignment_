import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/place_controller.dart';

class PlacePage extends StatelessWidget {
  final PlaceController controller = Get.find();

  PlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Places")),
      body: Obx(() {
        if (controller.currentLocation.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return Column(
          children: [
            Expanded(
                child: GoogleMap(
              zoomControlsEnabled: false,
              // zoomGesturesEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  controller.currentLocation.value!.latitude,
                  controller.currentLocation.value!.longitude,
                ),
                zoom: 14.0,
              ),
              markers: {
                ...controller.nearbyPlaces.map((place) {
                  return Marker(
                    markerId: MarkerId(place.id),
                    position: LatLng(place.latitude, place.longitude),
                    infoWindow: InfoWindow(
                      title: place.name,
                      snippet: "Add to favoirite ",
                      onTap: () {
                        controller.toggleFavoritePlace(place);
                      },
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
                  );
                }).toSet(),
                ...controller.favoritePlaces.map((place) {
                  return Marker(
                    markerId: MarkerId(place.id),
                    position: LatLng(place.latitude, place.longitude),
                    infoWindow: InfoWindow(
                      title: place.name,
                      snippet: "Remove favoirite",
                      onTap: () {
                        controller.toggleFavoritePlace(place);
                      },
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                  );
                }).toSet(),
              },
            )),
            Expanded(
              child: ListView.builder(
                itemCount: controller.favoritePlaces.length,
                itemBuilder: (context, index) {
                  final place = controller.favoritePlaces[index];
                  return ListTile(
                    title: Text(place.name),
                    subtitle: Text("Rating: ${place.rating}"),
                    trailing: IconButton(
                      icon: Icon(
                        controller.favoritePlaces.any((p) => p.id == place.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      onPressed: () {
                        controller.toggleFavoritePlace(place);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
