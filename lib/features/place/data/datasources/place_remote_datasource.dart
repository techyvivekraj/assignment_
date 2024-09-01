import 'dart:convert';

import 'package:assignment/core/constants/constants.dart';
// import 'package:assignment/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';

abstract class PlaceRemoteDataSource {
  Future<List<PlaceModel>> getNearbyPlaces(
      double latitude, double longitude, String searchType);
}

class PlaceRemoteDataSourceImpl implements PlaceRemoteDataSource {
  final http.Client client;

  PlaceRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PlaceModel>> getNearbyPlaces(
      double latitude, double longitude, String searchType) async {
    const apiKey = AppConstants.googleApiKey;
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=$searchType&key=$apiKey';
    print(url);
    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body) as Map<String, dynamic>;
      return (parsed['results'] as List)
          .map<PlaceModel>((json) => PlaceModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load nearby places');
      // throw ApiException('Error fetching nearby places');
    }
  }
}
