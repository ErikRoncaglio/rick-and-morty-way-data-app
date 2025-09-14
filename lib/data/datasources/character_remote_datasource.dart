import 'package:dio/dio.dart';
import '../models/character_model.dart';

abstract class CharacterRemoteDataSource {
  Future<List<CharacterModel>> getCharacters({String? status});
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CharacterModel>> getCharacters({String? status}) async {
    try {
      String url = 'https://rickandmortyapi.com/api/character';

      // Adicionar parâmetro de status se fornecido
      if (status != null && status.isNotEmpty) {
        url += '?status=$status';
      }

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => CharacterModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Error fetching characters: $e');
    }
  }
}
