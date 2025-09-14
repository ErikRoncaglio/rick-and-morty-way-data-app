import '../entities/character_entity.dart';
import '../repositories/character_repository.dart';

class GetAllCharacters {
  final CharacterRepository repository;

  GetAllCharacters(this.repository);

  Future<List<CharacterEntity>> call({String? status}) async {
    return await repository.getCharacters(status: status);
  }
}
