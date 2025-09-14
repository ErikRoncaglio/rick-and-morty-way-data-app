import 'package:hive/hive.dart';
import '../models/character_model.dart';

abstract class CharacterLocalDataSource {
  Future<void> cacheCharacters(List<CharacterModel> characters, {String? status});
  Future<List<CharacterModel>> getLastCharacters({String? status});
  Future<void> clearCache();
}

class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  static const String _boxName = 'characters';

  @override
  Future<void> cacheCharacters(List<CharacterModel> characters, {String? status}) async {
    final box = Hive.box<CharacterModel>(_boxName);

    // Se há filtro, usar uma chave específica para o cache
    String cacheKey = status ?? 'all';

    // Limpar cache anterior para este filtro específico
    final keysToRemove = box.keys.where((key) => key.toString().startsWith('${cacheKey}_')).toList();
    for (final key in keysToRemove) {
      await box.delete(key);
    }

    // Adicionar novos personagens com chave específica do filtro
    for (int i = 0; i < characters.length; i++) {
      final character = characters[i];
      await box.put('${cacheKey}_${character.id}', character);
    }
  }

  @override
  Future<List<CharacterModel>> getLastCharacters({String? status}) async {
    final box = Hive.box<CharacterModel>(_boxName);
    String cacheKey = status ?? 'all';

    // Buscar apenas os personagens do filtro específico
    final filteredCharacters = <CharacterModel>[];
    for (final key in box.keys) {
      if (key.toString().startsWith('${cacheKey}_')) {
        final character = box.get(key);
        if (character != null) {
          filteredCharacters.add(character);
        }
      }
    }

    return filteredCharacters;
  }

  @override
  Future<void> clearCache() async {
    final box = Hive.box<CharacterModel>(_boxName);
    await box.clear();
  }
}
