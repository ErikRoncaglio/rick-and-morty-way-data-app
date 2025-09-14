import 'package:hive/hive.dart';
import '../../domain/entities/location_entity.dart';

part 'location_model.g.dart';

@HiveType(typeId: 1)
class LocationModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String dimension;

  @HiveField(4)
  final List<String> residents;

  @HiveField(5)
  final String url;

  @HiveField(6)
  final String created;

  LocationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
    required this.url,
    required this.created,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      dimension: json['dimension'] ?? '',
      residents: List<String>.from(json['residents'] ?? []),
      url: json['url'] ?? '',
      created: json['created'] ?? '',
    );
  }

  LocationEntity toEntity() {
    return LocationEntity(
      id: id,
      name: name,
      type: type,
      dimension: dimension,
    );
  }
}
