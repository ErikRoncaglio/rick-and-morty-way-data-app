import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Rick and Morty'**
  String get appTitle;

  /// No description provided for @characterListTitle.
  ///
  /// In pt, this message translates to:
  /// **'Personagens Rick and Morty'**
  String get characterListTitle;

  /// No description provided for @characterDetails.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes do Personagem'**
  String get characterDetails;

  /// No description provided for @characters.
  ///
  /// In pt, this message translates to:
  /// **'Personagens'**
  String get characters;

  /// No description provided for @locations.
  ///
  /// In pt, this message translates to:
  /// **'Locais'**
  String get locations;

  /// No description provided for @episodes.
  ///
  /// In pt, this message translates to:
  /// **'Episódios'**
  String get episodes;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settings;

  /// No description provided for @loading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando...'**
  String get loading;

  /// No description provided for @errorLoadingCharacters.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar personagens'**
  String get errorLoadingCharacters;

  /// No description provided for @tryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Tentar Novamente'**
  String get tryAgain;

  /// No description provided for @noCharactersFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum personagem encontrado'**
  String get noCharactersFound;

  /// No description provided for @noLocationsFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum local encontrado'**
  String get noLocationsFound;

  /// No description provided for @noEpisodesFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum episódio encontrado'**
  String get noEpisodesFound;

  /// No description provided for @theme.
  ///
  /// In pt, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In pt, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In pt, this message translates to:
  /// **'Escuro'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @languagePortuguese.
  ///
  /// In pt, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageEnglish.
  ///
  /// In pt, this message translates to:
  /// **'Inglês'**
  String get languageEnglish;

  /// No description provided for @species.
  ///
  /// In pt, this message translates to:
  /// **'Espécie'**
  String get species;

  /// No description provided for @status.
  ///
  /// In pt, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @alive.
  ///
  /// In pt, this message translates to:
  /// **'Vivo'**
  String get alive;

  /// No description provided for @dead.
  ///
  /// In pt, this message translates to:
  /// **'Morto'**
  String get dead;

  /// No description provided for @unknown.
  ///
  /// In pt, this message translates to:
  /// **'Desconhecido'**
  String get unknown;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @all.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get all;

  /// No description provided for @gender.
  ///
  /// In pt, this message translates to:
  /// **'Gênero'**
  String get gender;

  /// No description provided for @origin.
  ///
  /// In pt, this message translates to:
  /// **'Origem'**
  String get origin;

  /// No description provided for @lastKnownLocation.
  ///
  /// In pt, this message translates to:
  /// **'Última Localização'**
  String get lastKnownLocation;

  /// No description provided for @episodeCount.
  ///
  /// In pt, this message translates to:
  /// **'Aparições em Episódios'**
  String get episodeCount;

  /// No description provided for @male.
  ///
  /// In pt, this message translates to:
  /// **'Masculino'**
  String get male;

  /// No description provided for @female.
  ///
  /// In pt, this message translates to:
  /// **'Feminino'**
  String get female;

  /// No description provided for @genderless.
  ///
  /// In pt, this message translates to:
  /// **'Sem Gênero'**
  String get genderless;

  /// No description provided for @generalInformation.
  ///
  /// In pt, this message translates to:
  /// **'Informações Gerais'**
  String get generalInformation;

  /// No description provided for @settingsDescription.
  ///
  /// In pt, this message translates to:
  /// **'As configurações são salvas automaticamente e aplicadas imediatamente.'**
  String get settingsDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
