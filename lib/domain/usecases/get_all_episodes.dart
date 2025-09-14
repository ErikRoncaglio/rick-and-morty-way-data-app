import '../entities/episode_entity.dart';
import '../repositories/episode_repository.dart';

class GetAllEpisodes {
  final EpisodeRepository repository;
  GetAllEpisodes(this.repository);

  Future<Map<String, dynamic>> call({int page = 1}) async {
    return await repository.getEpisodes(page: page);
  }
}
