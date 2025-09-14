abstract class EpisodeRepository {
  Future<Map<String, dynamic>> getEpisodes({int page = 1});
}
