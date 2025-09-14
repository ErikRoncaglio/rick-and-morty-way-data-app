import 'package:flutter/material.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/usecases/get_all_characters.dart';

class CharacterProvider extends ChangeNotifier {
  final GetAllCharacters getAllCharacters;

  CharacterProvider(this.getAllCharacters);

  bool _isLoading = false;
  List<CharacterEntity> _characters = [];
  String? _errorMessage;
  String? _selectedStatus; // Estado para armazenar o filtro selecionado

  bool get isLoading => _isLoading;
  List<CharacterEntity> get characters => _characters;
  String? get errorMessage => _errorMessage;
  String? get selectedStatus => _selectedStatus;

  Future<void> fetchCharacters({String? status}) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedStatus = status;
    notifyListeners();

    try {
      _characters = await getAllCharacters(status: status);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar personagens: $e';
      _characters = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterCharacters(String? status) async {
    await fetchCharacters(status: status);
  }
}
