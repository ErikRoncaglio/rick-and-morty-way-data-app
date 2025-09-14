import 'package:flutter/material.dart';
import '../../domain/entities/episode_entity.dart';
import '../../domain/usecases/get_all_episodes.dart';

class EpisodeProvider extends ChangeNotifier {
  final GetAllEpisodes getAllEpisodes;

  EpisodeProvider(this.getAllEpisodes);

  bool _isLoading = false;
  List<EpisodeEntity> _episodes = [];
  String? _errorMessage;

  // Novos estados para paginação
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  bool get isLoading => _isLoading;
  List<EpisodeEntity> get episodes => _episodes;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;
  bool get isLoadMoreRunning => _isLoadMoreRunning;

  Future<void> fetchEpisodes() async {
    _isLoading = true;
    _errorMessage = null;
    _currentPage = 1;
    _episodes.clear(); // Limpar lista para nova busca
    notifyListeners();

    try {
      final response = await getAllEpisodes(page: _currentPage);
      final List<EpisodeEntity> newEpisodes = (response['results'] as List)
          .cast<EpisodeEntity>();

      _episodes = newEpisodes;
      _errorMessage = null;

      // Verificar se há próxima página
      final info = response['info'] as Map<String, dynamic>;
      _hasNextPage = info['next'] != null;

    } catch (e) {
      _errorMessage = 'Erro ao carregar episódios: $e';
      _episodes = [];
      _hasNextPage = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreEpisodes() async {
    // Só executar se há próxima página e não está carregando
    if (!_hasNextPage || _isLoadMoreRunning) return;

    _isLoadMoreRunning = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await getAllEpisodes(page: nextPage);

      final List<EpisodeEntity> newEpisodes = (response['results'] as List)
          .cast<EpisodeEntity>();

      // Adicionar novos episódios à lista existente
      _episodes.addAll(newEpisodes);
      _currentPage = nextPage;

      // Verificar se há próxima página
      final info = response['info'] as Map<String, dynamic>;
      _hasNextPage = info['next'] != null;

    } catch (e) {
      // Em caso de erro, não atualizar a lista
      _errorMessage = 'Erro ao carregar mais episódios: $e';
    } finally {
      _isLoadMoreRunning = false;
      notifyListeners();
    }
  }
}
