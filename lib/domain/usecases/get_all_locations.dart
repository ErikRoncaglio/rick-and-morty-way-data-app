import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetAllLocations {
  final LocationRepository repository;
  GetAllLocations(this.repository);

  Future<Map<String, dynamic>> call({int page = 1}) async {
    return await repository.getLocations(page: page);
  }
}
