abstract class LocationRepository {
  Future<Map<String, dynamic>> getLocations({int page = 1});
}
