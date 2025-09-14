import '../../domain/repositories/episode_repository.dart';
import '../datasources/episode_local_datasource.dart';
import '../datasources/episode_remote_datasource.dart';
import '../models/episode_model.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final EpisodeRemoteDataSource remoteDataSource;
  final EpisodeLocalDataSource localDataSource;

  EpisodeRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Map<String, dynamic>> getEpisodes({int page = 1}) async {
    try {
      // Buscar da API com paginação
      final apiResponse = await remoteDataSource.getEpisodes(page: page);

      // Extrair os episódios da resposta
      final List<dynamic> results = apiResponse['results'];
      final newEpisodeModels = results.map((json) => EpisodeModel.fromJson(json)).toList();

      // Estratégia de cache: combinar com dados existentes
      List<EpisodeModel> allEpisodes = [];

      if (page == 1) {
        // Se é a primeira página, limpar cache anterior e usar apenas os novos dados
        allEpisodes = newEpisodeModels;
      } else {
        // Se é uma página subsequente, combinar com dados já existentes
        try {
          final cachedEpisodes = await localDataSource.getLastEpisodes();
          allEpisodes = [...cachedEpisodes];

          // Adicionar novos episódios evitando duplicatas
          for (final newEpisode in newEpisodeModels) {
            final exists = allEpisodes.any((existing) => existing.id == newEpisode.id);
            if (!exists) {
              allEpisodes.add(newEpisode);
            }
          }
        } catch (e) {
          // Se falhou ao ler cache, usar apenas os novos dados
          allEpisodes = newEpisodeModels;
        }
      }

      // Salvar a lista completa e combinada no cache
      await localDataSource.cacheEpisodes(allEpisodes);

      // Retornar resposta com informações de paginação e entidades
      return {
        'info': apiResponse['info'],
        'results': newEpisodeModels.map((model) => model.toEntity()).toList(),
      };

    } catch (e) {
      // Se falhou ao buscar da API, tentar buscar do cache local
      try {
        final cachedEpisodes = await localDataSource.getLastEpisodes();

        if (cachedEpisodes.isNotEmpty) {
          // Retornar dados do cache com info de paginação vazia
          return {
            'info': {'next': null, 'prev': null},
            'results': cachedEpisodes.map((model) => model.toEntity()).toList(),
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
