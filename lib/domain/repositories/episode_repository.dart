import '../entities/episode_entity.dart';
abstract class EpisodeRepository {
  Future<Map<String, dynamic>> getEpisodes({int page = 1});
}
