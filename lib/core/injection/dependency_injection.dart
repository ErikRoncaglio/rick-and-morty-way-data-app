import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/character_local_datasource.dart';
import '../../data/datasources/character_remote_datasource.dart';
import '../../data/datasources/episode_local_datasource.dart';
import '../../data/datasources/episode_remote_datasource.dart';
import '../../data/datasources/location_local_datasource.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../data/repositories/episode_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/repositories/character_repository.dart';
import '../../domain/repositories/episode_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_all_characters.dart';
import '../../domain/usecases/get_all_episodes.dart';
import '../../domain/usecases/get_all_locations.dart';
import '../../presentation/providers/character_provider.dart';
import '../../presentation/providers/episode_provider.dart';
import '../../presentation/providers/location_provider.dart';
import '../../presentation/providers/settings_provider.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External
  getIt.registerLazySingleton<Dio>(() => Dio());

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Data sources - Characters
  getIt.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<CharacterLocalDataSource>(
    () => CharacterLocalDataSourceImpl(),
  );

  // Data sources - Locations
  getIt.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(),
  );

  // Data sources - Episodes
  getIt.registerLazySingleton<EpisodeRemoteDataSource>(
    () => EpisodeRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<EpisodeLocalDataSource>(
    () => EpisodeLocalDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton<EpisodeRepository>(
    () => EpisodeRepositoryImpl(getIt(), getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetAllCharacters(getIt()));
  getIt.registerLazySingleton(() => GetAllLocations(getIt()));
  getIt.registerLazySingleton(() => GetAllEpisodes(getIt()));

  // Providers
  getIt.registerFactory(() => CharacterProvider(getIt()));
  getIt.registerFactory(() => LocationProvider(getIt()));
  getIt.registerFactory(() => EpisodeProvider(getIt()));
  getIt.registerLazySingleton(() => SettingsProvider(getIt()));
}
