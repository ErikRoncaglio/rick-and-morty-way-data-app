import 'package:flutter/material.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/usecases/get_all_characters.dart';

class CharacterProvider extends ChangeNotifier {
  final GetAllCharacters getAllCharacters;

  CharacterProvider(this.getAllCharacters);

  bool _isLoading = false;
  List<CharacterEntity> _characters = [];
  String? _errorMessage;
  String? _selectedStatus;

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  bool get isLoading => _isLoading;
  List<CharacterEntity> get characters => _characters;
  String? get errorMessage => _errorMessage;
  String? get selectedStatus => _selectedStatus;
  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;
  bool get isLoadMoreRunning => _isLoadMoreRunning;

  Future<void> fetchCharacters({String? status}) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedStatus = status;
    _currentPage = 1;
    _characters.clear();
    notifyListeners();

    try {
      final response = await getAllCharacters(
        page: _currentPage,
        status: status,
      );
      final List<CharacterEntity> newCharacters = (response['results'] as List)
          .cast<CharacterEntity>();

      _characters = newCharacters;
      _errorMessage = null;

      // Verificar se há próxima página
      final info = response['info'] as Map<String, dynamic>;
      _hasNextPage = info['next'] != null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar personagens: $e';
      _characters = [];
      _hasNextPage = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreCharacters() async {
    // Só executar se há próxima página e não está carregando
    if (!_hasNextPage || _isLoadMoreRunning) return;

    _isLoadMoreRunning = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await getAllCharacters(
        page: nextPage,
        status: _selectedStatus,
      );

      final List<CharacterEntity> newCharacters = (response['results'] as List)
          .cast<CharacterEntity>();

      // Adicionar novos personagens à lista existente
      _characters.addAll(newCharacters);
      _currentPage = nextPage;

      // Verificar se há próxima página
      final info = response['info'] as Map<String, dynamic>;
      _hasNextPage = info['next'] != null;
    } catch (e) {
      // Em caso de erro, não atualizar a lista
      _errorMessage = 'Erro ao carregar mais personagens: $e';
    } finally {
      _isLoadMoreRunning = false;
      notifyListeners();
    }
  }

  Future<void> filterCharacters(String? status) async {
    await fetchCharacters(status: status);
  }
}
