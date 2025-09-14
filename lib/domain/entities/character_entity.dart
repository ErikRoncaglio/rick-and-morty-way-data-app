class CharacterEntity {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String gender;
  final String originName;
  final String lastKnownLocation;
  final int episodeCount;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.gender,
    required this.originName,
    required this.lastKnownLocation,
    required this.episodeCount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharacterEntity &&
        other.id == id &&
        other.name == name &&
        other.status == status &&
        other.species == species &&
        other.image == image &&
        other.gender == gender &&
        other.originName == originName &&
        other.lastKnownLocation == lastKnownLocation &&
        other.episodeCount == episodeCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      status,
      species,
      image,
      gender,
      originName,
      lastKnownLocation,
      episodeCount,
    );
  }
}
