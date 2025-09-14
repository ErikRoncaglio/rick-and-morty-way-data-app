import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_datasource.dart';
import '../datasources/location_remote_datasource.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationLocalDataSource localDataSource;

  LocationRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Map<String, dynamic>> getLocations({int page = 1}) async {
    try {
      // Buscar da API com paginação
      final apiResponse = await remoteDataSource.getLocations(page: page);

      // Extrair os locais da resposta
      final List<dynamic> results = apiResponse['results'];
      final newLocationModels = results.map((json) => LocationModel.fromJson(json)).toList();

      // Estratégia de cache: combinar com dados existentes
      List<LocationModel> allLocations = [];

      if (page == 1) {
        // Se é a primeira página, limpar cache anterior e usar apenas os novos dados
        allLocations = newLocationModels;
      } else {
        // Se é uma página subsequente, combinar com dados já existentes
        try {
          final cachedLocations = await localDataSource.getLastLocations();
          allLocations = [...cachedLocations];

          // Adicionar novos locais evitando duplicatas
          for (final newLocation in newLocationModels) {
            final exists = allLocations.any((existing) => existing.id == newLocation.id);
            if (!exists) {
              allLocations.add(newLocation);
            }
          }
        } catch (e) {
          // Se falhou ao ler cache, usar apenas os novos dados
          allLocations = newLocationModels;
        }
      }

      // Salvar a lista completa e combinada no cache
      await localDataSource.cacheLocations(allLocations);

      // Retornar resposta com informações de paginação e entidades
      return {
        'info': apiResponse['info'],
        'results': newLocationModels.map((model) => model.toEntity()).toList(),
      };

    } catch (e) {
      // Se falhou ao buscar da API, tentar buscar do cache local
      try {
        final cachedLocations = await localDataSource.getLastLocations();

        if (cachedLocations.isNotEmpty) {
          // Retornar dados do cache com info de paginação vazia
          return {
            'info': {'next': null, 'prev': null},
            'results': cachedLocations.map((model) => model.toEntity()).toList(),
          };
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
