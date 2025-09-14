import 'package:hive/hive.dart';
import '../../domain/entities/character_entity.dart';

part 'character_model.g.dart';

@HiveType(typeId: 0)
class CharacterModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String gender;

  @HiveField(5)
  final String image;

  @HiveField(6)
  final String originName;

  @HiveField(7)
  final String locationName;

  @HiveField(8)
  final List<String> episodes;

  @HiveField(9)
  final String created;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.originName,
    required this.locationName,
    required this.episodes,
    required this.created,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',
      originName: json['origin']?['name'] ?? '',
      locationName: json['location']?['name'] ?? '',
      episodes: List<String>.from(json['episode'] ?? []),
      created: json['created'] ?? '',
    );
  }

  CharacterEntity toEntity() {
    return CharacterEntity(
      id: id,
      name: name,
      status: status,
      species: species,
      image: image,
      gender: gender,
      originName: originName,
      lastKnownLocation: locationName,
      episodeCount: episodes.length,
    );
  }
}
