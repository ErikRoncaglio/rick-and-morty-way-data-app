import 'package:dio/dio.dart';

abstract class CharacterRemoteDataSource {
  Future<Map<String, dynamic>> getCharacters({int page = 1, String? status});
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getCharacters({int page = 1, String? status}) async {
    try {
      String url = 'https://rickandmortyapi.com/api/character?page=$page';

      // Adicionar parâmetro de status se fornecido
      if (status != null && status.isNotEmpty) {
        url += '&status=$status';
      }

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Error fetching characters: $e');
    }
  }
}
