class LocationPermissionDeniedException implements Exception {}

class NoNearbyPlacesFoundException implements Exception {}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}
