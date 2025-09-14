import 'package:flutter/material.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/usecases/get_all_locations.dart';

class LocationProvider extends ChangeNotifier {
  final GetAllLocations getAllLocations;

  LocationProvider(this.getAllLocations);

  bool _isLoading = false;
  List<LocationEntity> _locations = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<LocationEntity> get locations => _locations;
  String? get errorMessage => _errorMessage;

  Future<void> fetchLocations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _locations = await getAllLocations();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar locais: $e';
      _locations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
