import '../entities/episode_entity.dart';
import '../repositories/episode_repository.dart';

class GetAllEpisodes {
  final EpisodeRepository repository;
  GetAllEpisodes(this.repository);

  Future<List<EpisodeEntity>> call() async {
    return await repository.getEpisodes();
  }
}

