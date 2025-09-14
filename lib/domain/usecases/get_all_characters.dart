import '../entities/character_entity.dart';
import '../repositories/character_repository.dart';

class GetAllCharacters {
  final CharacterRepository repository;

  GetAllCharacters(this.repository);

  Future<Map<String, dynamic>> call({int page = 1, String? status}) async {
    return await repository.getCharacters(page: page, status: status);
  }
}
