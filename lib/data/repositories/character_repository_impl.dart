import '../../domain/repositories/character_repository.dart';
import '../datasources/character_local_datasource.dart';
import '../datasources/character_remote_datasource.dart';
import '../models/character_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;

  CharacterRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Map<String, dynamic>> getCharacters({int page = 1, String? status}) async {
    try {
      // Buscar da API com paginação
      final apiResponse = await remoteDataSource.getCharacters(page: page, status: status);

      // Extrair os personagens da resposta
      final List<dynamic> results = apiResponse['results'];
      final newCharacterModels = results.map((json) => CharacterModel.fromJson(json)).toList();

      // Estratégia de cache: combinar com dados existentes
      List<CharacterModel> allCharacters = [];

      if (page == 1) {
        // Se é a primeira página, limpar cache anterior e usar apenas os novos dados
        allCharacters = newCharacterModels;
      } else {
        // Se é uma página subsequente, combinar com dados já existentes
        try {
          final cachedCharacters = await localDataSource.getLastCharacters(status: status);
          allCharacters = [...cachedCharacters];

          // Adicionar novos personagens evitando duplicatas
          for (final newCharacter in newCharacterModels) {
            final exists = allCharacters.any((existing) => existing.id == newCharacter.id);
            if (!exists) {
              allCharacters.add(newCharacter);
            }
          }
        } catch (e) {
          // Se falhou ao ler cache, usar apenas os novos dados
          allCharacters = newCharacterModels;
        }
      }

      // Salvar a lista completa e combinada no cache
      await localDataSource.cacheCharacters(allCharacters, status: status);

      // Retornar resposta com informações de paginação e entidades
      return {
        'info': apiResponse['info'],
        'results': newCharacterModels.map((model) => model.toEntity()).toList(),
      };

    } catch (e) {
      // Se falhou ao buscar da API, tentar buscar do cache local
      try {
        final cachedCharacters = await localDataSource.getLastCharacters(status: status);

        if (cachedCharacters.isNotEmpty) {
          // Retornar dados do cache com info de paginação vazia
          return {
            'info': {'next': null, 'prev': null},
            'results': cachedCharacters.map((model) => model.toEntity()).toList(),
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
