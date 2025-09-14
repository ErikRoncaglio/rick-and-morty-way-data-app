import 'package:flutter/material.dart';
import '../../domain/entities/episode_entity.dart';
import '../../domain/usecases/get_all_episodes.dart';

class EpisodeProvider extends ChangeNotifier {
  final GetAllEpisodes getAllEpisodes;

  EpisodeProvider(this.getAllEpisodes);

  bool _isLoading = false;
  List<EpisodeEntity> _episodes = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<EpisodeEntity> get episodes => _episodes;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEpisodes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _episodes = await getAllEpisodes();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar episódios: $e';
      _episodes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
