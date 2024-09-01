import 'package:assignment/core/constants/constants.dart';
import 'package:assignment/features/place/presentation/widgets/favorite_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/place_controller.dart';

class PlacePage extends StatefulWidget {
  const PlacePage({super.key});

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  final PlaceController controller = Get.find();

  FilterOption _selectedFilter = FilterOption.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Places"),
        actions: [
          Obx(() {
            return DropdownButton<String>(
              value: controller.selectedPlaceType.value,
              items: <String>[
                'restaurant',
                'hospital',
                'school',
                'college',
                'cafe',
                'park',
                'museum'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.capitalizeFirst!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.updatePlaceType(newValue);
                }
              },
              dropdownColor: Colors.white,
              underline: Container(),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: controller.currentLocation.value != null
                    ? Visibility(
                        visible: controller.currentLocation.value != null,
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
                                position:
                                    LatLng(place.latitude, place.longitude),
                                infoWindow: InfoWindow(
                                  title: place.name,
                                  snippet: place.rating != null
                                      ? "Rating: ${place.rating}"
                                      : "No Rating Available",
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
                                position:
                                    LatLng(place.latitude, place.longitude),
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
                        ),
                      )
                    : const Center(
                        child: Text('Location fetching'),
                      )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Nearby Places",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<FilterOption>(
                        value: _selectedFilter,
                        items: const [
                          DropdownMenuItem(
                            value: FilterOption.all,
                            child: Text('All'),
                          ),
                          DropdownMenuItem(
                            value: FilterOption.open,
                            child: Text('Open Now'),
                          ),
                          DropdownMenuItem(
                            value: FilterOption.highRating,
                            child: Text('Highly Rated'),
                          ),
                        ],
                        onChanged: (FilterOption? newValue) {
                          setState(() {
                            _selectedFilter = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  TextButton.icon(
                      icon: const Icon(Icons.star),
                      onPressed: () {
                        showFavoritePlacesBottomSheet(
                            context, controller.favoritePlaces);
                      },
                      label: const Text("Open Favorite List"))
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.nearbyPlaces.length,
                itemBuilder: (context, index) {
                  final place = controller.nearbyPlaces[index];
                  bool shouldShow = false;
                  switch (_selectedFilter) {
                    case FilterOption.open:
                      shouldShow = place.isOpen;
                      break;
                    case FilterOption.highRating:
                      shouldShow = place.rating != null && place.rating! >= 4.0;
                      break;
                    case FilterOption.all:
                    default:
                      shouldShow = true;
                      break;
                  }

                  if (!shouldShow) {
                    return const SizedBox.shrink();
                  }

                  if (controller.nearbyPlaces.isEmpty) {
                    return const Center(
                      child: Text('No nearby places found'),
                    );
                  }
                  return ListTile(
                    title: Text(place.name),
                    subtitle: Text(
                      place.rating != null
                          ? "Rating: ${place.rating}"
                          : "No Rating Available",
                    ),
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
