import 'package:assignment/features/place/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';

void showFavoritePlacesBottomSheet(
    BuildContext context, List<PlaceEntity> favoritePlaces) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return ListView.builder(
        itemCount: favoritePlaces.length,
        itemBuilder: (context, index) {
          final place = favoritePlaces[index];
          if (favoritePlaces.isEmpty) {
            return const Center(
              child: Text("No Favorite added it"),
            );
          }
          return ListTile(
            title: Text(place.name),
            subtitle: Text('Rating: ${place.rating}'),
            // onTap: () {},
          );
        },
      );
    },
  );
}
