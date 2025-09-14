import 'package:hive/hive.dart';
import '../models/episode_model.dart';
abstract class EpisodeLocalDataSource {
  Future<void> cacheEpisodes(List<EpisodeModel> episodes);
  Future<List<EpisodeModel>> getLastEpisodes();
  Future<void> clearCache();
}

class EpisodeLocalDataSourceImpl implements EpisodeLocalDataSource {
  static const String _boxName = 'episodes';

  @override
  Future<void> cacheEpisodes(List<EpisodeModel> episodes) async {
    final box = Hive.box<EpisodeModel>(_boxName);

    // Limpar cache anterior
    await box.clear();

    // Adicionar novos episódios
    for (final episode in episodes) {
      await box.put(episode.id, episode);
    }
  }

  @override
  Future<List<EpisodeModel>> getLastEpisodes() async {
    final box = Hive.box<EpisodeModel>(_boxName);
    return box.values.toList();
  }

  @override
  Future<void> clearCache() async {
    final box = Hive.box<EpisodeModel>(_boxName);
    await box.clear();
  }
}

