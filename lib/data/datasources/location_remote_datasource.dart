import 'package:dio/dio.dart';

abstract class LocationRemoteDataSource {
  Future<Map<String, dynamic>> getLocations({int page = 1});
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final Dio dio;

  LocationRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getLocations({int page = 1}) async {
    try {
      final response = await dio.get('https://rickandmortyapi.com/api/location?page=$page');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      throw Exception('Error fetching locations: $e');
    }
  }
}
