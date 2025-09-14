import 'package:dio/dio.dart';
import '../models/episode_model.dart';

abstract class EpisodeRemoteDataSource {
  Future<List<EpisodeModel>> getEpisodes();
}

class EpisodeRemoteDataSourceImpl implements EpisodeRemoteDataSource {
  final Dio dio;

  EpisodeRemoteDataSourceImpl(this.dio);
  @override
  Future<List<EpisodeModel>> getEpisodes() async {
    try {
      final response = await dio.get('https://rickandmortyapi.com/api/episode');

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => EpisodeModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load episodes');
      }
    } catch (e) {
      throw Exception('Error fetching episodes: $e');
    }
  }
}

