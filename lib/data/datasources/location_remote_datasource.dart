import 'package:dio/dio.dart';
import '../models/location_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<LocationModel>> getLocations();
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final Dio dio;

  LocationRemoteDataSourceImpl(this.dio);
  @override
  Future<List<LocationModel>> getLocations() async {
    try {
      final response = await dio.get('https://rickandmortyapi.com/api/location');

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => LocationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      throw Exception('Error fetching locations: $e');
    }
  }
}

