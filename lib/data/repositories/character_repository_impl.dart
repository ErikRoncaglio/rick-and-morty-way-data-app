import '../../domain/entities/character_entity.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_local_datasource.dart';
import '../datasources/character_remote_datasource.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;

  CharacterRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<CharacterEntity>> getCharacters({String? status}) async {
    try {
      // Tentar buscar da API primeiro (offline-first strategy) com filtro
      final characterModels = await remoteDataSource.getCharacters(status: status);

      // Se conseguiu buscar da API, salvar no cache local com o filtro específico
      await localDataSource.cacheCharacters(characterModels, status: status);

      // Retornar dados da API convertidos para entidades
      return characterModels.map((model) => model.toEntity()).toList();

    } catch (e) {
      // Se falhou ao buscar da API, tentar buscar do cache local
      try {
        final cachedCharacters = await localDataSource.getLastCharacters(status: status);

        if (cachedCharacters.isNotEmpty) {
          // Retornar dados do cache convertidos para entidades
          return cachedCharacters.map((model) => model.toEntity()).toList();
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
