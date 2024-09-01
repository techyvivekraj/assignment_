import 'package:assignment/injection_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  FirebaseAuth auth = FirebaseAuth.instance;
  String get userId => auth.currentUser?.uid ?? '';
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
    if (userId.isEmpty) {
      throw Exception("User is not logged in.");
    }
    await firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(place.id)
        .set({
      'name': place.name,
      'latitude': place.latitude,
      'longitude': place.longitude,
      'rating': place.rating,
      'isOpen': place.isOpen,
    });
  }

  @override
  Future<void> removeFavoritePlace(String placeId) async {
    if (userId.isEmpty) {
      throw Exception("User is not logged in.");
    }
    await firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(placeId)
        .delete();
  }

  @override
  Future<List<PlaceEntity>> getFavoritePlaces() async {
    if (userId.isEmpty) {
      throw Exception("User is not logged in.");
    }
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    return snapshot.docs.map((doc) {
      return PlaceEntity(
        id: doc.id,
        name: doc['name'],
        latitude: doc['latitude'],
        longitude: doc['longitude'],
        rating: doc['rating'] ?? 0,
        isOpen: doc['isOpen'],
      );
    }).toList();
  }
}
