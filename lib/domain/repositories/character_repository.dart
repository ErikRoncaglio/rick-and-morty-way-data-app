abstract class CharacterRepository {
  Future<Map<String, dynamic>> getCharacters({int page = 1, String? status});
}
