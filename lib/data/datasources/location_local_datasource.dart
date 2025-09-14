import 'package:hive/hive.dart';
import '../models/location_model.dart';
abstract class LocationLocalDataSource {
  Future<void> cacheLocations(List<LocationModel> locations);
  Future<List<LocationModel>> getLastLocations();
  Future<void> clearCache();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  static const String _boxName = 'locations';

  @override
  Future<void> cacheLocations(List<LocationModel> locations) async {
    final box = Hive.box<LocationModel>(_boxName);

    // Limpar cache anterior
    await box.clear();

    // Adicionar novos locais
    for (final location in locations) {
      await box.put(location.id, location);
    }
  }

  @override
  Future<List<LocationModel>> getLastLocations() async {
    final box = Hive.box<LocationModel>(_boxName);
    return box.values.toList();
  }

  @override
  Future<void> clearCache() async {
    final box = Hive.box<LocationModel>(_boxName);
    await box.clear();
  }
}

