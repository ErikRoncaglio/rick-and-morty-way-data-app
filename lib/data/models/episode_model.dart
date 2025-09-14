import 'package:hive/hive.dart';
import '../../domain/entities/episode_entity.dart';

part 'episode_model.g.dart';

@HiveType(typeId: 2)
class EpisodeModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String airDate;

  @HiveField(3)
  final String episode;

  @HiveField(4)
  final List<String> characters;
  @HiveField(5)
  final String url;

  @HiveField(6)
  final String created;

  EpisodeModel({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
    required this.url,
    required this.created,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      airDate: json['air_date'] ?? '',
      episode: json['episode'] ?? '',
      characters: List<String>.from(json['characters'] ?? []),
      url: json['url'] ?? '',
      created: json['created'] ?? '',
    );
  }

  EpisodeEntity toEntity() {
    return EpisodeEntity(
      id: id,
      name: name,
      airDate: airDate,
      episode: episode,
    );
  }
}

