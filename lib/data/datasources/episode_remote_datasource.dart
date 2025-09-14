import 'package:dio/dio.dart';

abstract class EpisodeRemoteDataSource {
  Future<Map<String, dynamic>> getEpisodes({int page = 1});
}

class EpisodeRemoteDataSourceImpl implements EpisodeRemoteDataSource {
  final Dio dio;

  EpisodeRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getEpisodes({int page = 1}) async {
    try {
      final response = await dio.get('https://rickandmortyapi.com/api/episode?page=$page');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load episodes');
      }
    } catch (e) {
      throw Exception('Error fetching episodes: $e');
    }
  }
}
