import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_datasource.dart';
import '../datasources/location_remote_datasource.dart';
class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationLocalDataSource localDataSource;

  LocationRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<LocationEntity>> getLocations() async {
    try {
      // Tentar buscar da API primeiro (offline-first strategy)
      final locationModels = await remoteDataSource.getLocations();

      // Se conseguiu buscar da API, salvar no cache local
      await localDataSource.cacheLocations(locationModels);

      // Retornar dados da API convertidos para entidades
      return locationModels.map((model) => model.toEntity()).toList();

    } catch (e) {
      // Se falhou ao buscar da API, tentar buscar do cache local
      try {
        final cachedLocations = await localDataSource.getLastLocations();

        if (cachedLocations.isNotEmpty) {
          // Retornar dados do cache convertidos para entidades
          return cachedLocations.map((model) => model.toEntity()).toList();
        } else {
          // Se não há dados em cache, lançar erro
          throw Exception('No cached data available and API request failed: $e');
        }
      } catch (cacheError) {
        // Se tanto a API quanto o cache falharam
        throw Exception('Both API and cache failed: API error: $e, Cache error: $cacheError');
      }
    }
  }
}

