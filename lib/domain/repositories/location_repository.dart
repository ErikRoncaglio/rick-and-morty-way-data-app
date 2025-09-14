import '../entities/location_entity.dart';
abstract class LocationRepository {
  Future<Map<String, dynamic>> getLocations({int page = 1});
}
