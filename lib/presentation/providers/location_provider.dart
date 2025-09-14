import 'package:flutter/material.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/usecases/get_all_locations.dart';

class LocationProvider extends ChangeNotifier {
  final GetAllLocations getAllLocations;

  LocationProvider(this.getAllLocations);

  bool _isLoading = false;
  List<LocationEntity> _locations = [];
  String? _errorMessage;

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  bool get isLoading => _isLoading;
  List<LocationEntity> get locations => _locations;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;
  bool get isLoadMoreRunning => _isLoadMoreRunning;

  Future<void> fetchLocations() async {
    _isLoading = true;
    _errorMessage = null;
    _currentPage = 1;
    _locations.clear();
    notifyListeners();

    try {
      final response = await getAllLocations(page: _currentPage);
      final List<LocationEntity> newLocations = (response['results'] as List)
          .cast<LocationEntity>();

      _locations = newLocations;
      _errorMessage = null;

      // Verificar se há próxima página
      final info = response['info'] as Map<String, dynamic>;
      _hasNextPage = info['next'] != null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar locais: $e';
      _locations = [];
      _hasNextPage = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreLocations() async {
    // Só executar se há próxima página e não está carregando
    if (!_hasNextPage || _isLoadMoreRunning) return;

    _isLoadMoreRunning = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await getAllLocations(page: nextPage);

      final List<LocationEntity> newLocations = (response['results'] as List)
          .cast<LocationEntity>();

      // Adicionar novos locais à lista existente
      _locations.addAll(newLocations);
      _currentPage = nextPage;

      // Verificar se há próxima página
      final info = response['info'] as Map<String, dynamic>;
      _hasNextPage = info['next'] != null;
    } catch (e) {
      // Em caso de erro, não atualizar a lista
      _errorMessage = 'Erro ao carregar mais locais: $e';
    } finally {
      _isLoadMoreRunning = false;
      notifyListeners();
    }
  }
}
