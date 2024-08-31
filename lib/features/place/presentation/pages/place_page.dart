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

        return Column(
          children: [
            Expanded(
              child: GoogleMap(
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    controller.currentLocation.value!.latitude,
                    controller.currentLocation.value!.longitude,
                  ),
                  zoom: 14.0,
                ),
                markers: Set<Marker>.of(controller.nearbyPlaces.map((place) {
                  return Marker(
                    markerId: MarkerId(place.id),
                    position: LatLng(place.latitude, place.longitude),
                    infoWindow: InfoWindow(
                      title: place.name,
                      snippet: "Rating: ${place.rating}",
                      onTap: () {
                        controller.toggleFavoritePlace(place);
                      },
                    ),
                  );
                })),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.nearbyPlaces.length,
                itemBuilder: (context, index) {
                  final place = controller.nearbyPlaces[index];
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
