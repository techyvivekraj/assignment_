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
    try {
      final places =
          await remoteDataSource.getNearbyPlaces(latitude, longitude);
      return places;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveFavoritePlace(PlaceEntity place) async {
    try {
      await firestore.collection('favorites').doc(place.id).set({
        'name': place.name,
        'latitude': place.latitude,
        'longitude': place.longitude,
        'rating': place.rating,
        'isOpen': place.isOpen,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFavoritePlace(String placeId) async {
    try {
      await firestore.collection('favorites').doc(placeId).delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlaceEntity>> getFavoritePlaces() async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }
}
