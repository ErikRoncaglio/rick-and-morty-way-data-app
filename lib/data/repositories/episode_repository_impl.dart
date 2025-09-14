import '../../domain/entities/episode_entity.dart';
import '../../domain/repositories/episode_repository.dart';
import '../datasources/episode_local_datasource.dart';
import '../datasources/episode_remote_datasource.dart';
class EpisodeRepositoryImpl implements EpisodeRepository {
  final EpisodeRemoteDataSource remoteDataSource;
  final EpisodeLocalDataSource localDataSource;

  EpisodeRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<EpisodeEntity>> getEpisodes() async {
    try {
      // Tentar buscar da API primeiro (offline-first strategy)
      final episodeModels = await remoteDataSource.getEpisodes();

      // Se conseguiu buscar da API, salvar no cache local
      await localDataSource.cacheEpisodes(episodeModels);

      // Retornar dados da API convertidos para entidades
      return episodeModels.map((model) => model.toEntity()).toList();

    } catch (e) {
      // Se falhou ao buscar da API, tentar buscar do cache local
      try {
        final cachedEpisodes = await localDataSource.getLastEpisodes();

        if (cachedEpisodes.isNotEmpty) {
          // Retornar dados do cache convertidos para entidades
          return cachedEpisodes.map((model) => model.toEntity()).toList();
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

