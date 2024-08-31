import 'dart:convert';
import 'package:assignment/core/constants/constants.dart';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';

abstract class PlaceRemoteDataSource {
  Future<List<PlaceModel>> getNearbyPlaces(double latitude, double longitude);
}

class PlaceRemoteDataSourceImpl implements PlaceRemoteDataSource {
  final http.Client client;

  PlaceRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PlaceModel>> getNearbyPlaces(
      double latitude, double longitude) async {
    const apiKey = AppConstants.googleApiKey;
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=restaurant&key=$apiKey';
    // print(url);
    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      try {
        final List results = json.decode(response.body)['results'];
        return results.map((place) => PlaceModel.fromJson(place)).toList();
      } catch (e) {
        throw Exception('parser $e');
      }
    } else {
      throw Exception('Failed to load nearby places');
    }
  }
}
