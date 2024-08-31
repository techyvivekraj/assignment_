import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/place_remote_datasource.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceRemoteDataSource remoteDataSource;
  final FirebaseFirestore firestore;

  PlaceRepositoryImpl({
    required this.remoteDataSource,
    required this.firestore,
  });

  @override
  Future<List<PlaceEntity>> getNearbyPlaces(
      double latitude, double longitude) async {
    final places = await remoteDataSource.getNearbyPlaces(latitude, longitude);
    return places;
  }

  @override
  Future<void> saveFavoritePlace(PlaceEntity place) async {
    await firestore.collection('favorites').doc(place.id).set({
      'name': place.name,
      'latitude': place.latitude,
      'longitude': place.longitude,
      'rating': place.rating,
      'isOpen': place.isOpen,
    });
  }

  @override
  Future<void> removeFavoritePlace(String placeId) async {
    await firestore.collection('favorites').doc(placeId).delete();
  }

  @override
  Future<List<PlaceEntity>> getFavoritePlaces() async {
    final snapshot = await firestore.collection('favorites').get();
    return snapshot.docs.map((doc) {
      return PlaceEntity(
        id: doc.id,
        name: doc['name'],
        latitude: doc['latitude'],
        longitude: doc['longitude'],
        rating: doc['rating'],
        isOpen: doc['isOpen'],
      );
    }).toList();
  }
}
