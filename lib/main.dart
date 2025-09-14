import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/injection/dependency_injection.dart' as di;
import 'core/theme/app_theme.dart';
import 'data/models/character_model.dart';
import 'data/models/episode_model.dart';
import 'data/models/location_model.dart';
import 'l10n/app_localizations.dart';
import 'presentation/providers/character_provider.dart';
import 'presentation/providers/episode_provider.dart';
import 'presentation/providers/location_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Hive
  await Hive.initFlutter();

  // Registrar os Adapters
  Hive.registerAdapter(CharacterModelAdapter());
  Hive.registerAdapter(LocationModelAdapter());
  Hive.registerAdapter(EpisodeModelAdapter());

  // Abrir as Boxes
  await Hive.openBox<CharacterModel>('characters');
  await Hive.openBox<LocationModel>('locations');
  await Hive.openBox<EpisodeModel>('episodes');

  // Inicializar injeção de dependência
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.getIt<CharacterProvider>()),
        ChangeNotifierProvider(create: (context) => di.getIt<LocationProvider>()),
        ChangeNotifierProvider(create: (context) => di.getIt<EpisodeProvider>()),
        ChangeNotifierProvider(create: (context) => di.getIt<SettingsProvider>()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'Rick and Morty App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.themeMode,
            locale: settingsProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('pt', 'BR'),
              Locale('en', 'US'),
            ],
            home: const HomePage(),
          );
        },
      ),
    );
  }
}