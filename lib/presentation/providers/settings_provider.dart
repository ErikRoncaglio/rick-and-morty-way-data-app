import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  // Chaves para SharedPreferences
  static const String _themeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('pt', 'BR');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  // Carregar configurações do SharedPreferences
  void _loadSettings() {
    // Carregar tema
    final themeString = _prefs.getString(_themeKey);
    if (themeString != null) {
      switch (themeString) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'system':
        default:
          _themeMode = ThemeMode.system;
          break;
      }
    }

    // Carregar idioma
    final localeString = _prefs.getString(_localeKey);
    if (localeString != null) {
      switch (localeString) {
        case 'en_US':
          _locale = const Locale('en', 'US');
          break;
        case 'pt_BR':
        default:
          _locale = const Locale('pt', 'BR');
          break;
      }
    }

    notifyListeners();
  }

  // Alterar tema
  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;

    String themeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
      default:
        themeString = 'system';
        break;
    }

    await _prefs.setString(_themeKey, themeString);
    notifyListeners();
  }

  // Alterar idioma
  Future<void> setLocale(Locale locale) async {
    _locale = locale;

    String localeString;
    if (locale.languageCode == 'en') {
      localeString = 'en_US';
    } else {
      localeString = 'pt_BR';
    }

    await _prefs.setString(_localeKey, localeString);
    notifyListeners();
  }

  // Métodos auxiliares para UI
  String getThemeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
      default:
        return 'System';
    }
  }

  String getLocaleDisplayName(Locale locale) {
    if (locale.languageCode == 'en') {
      return 'English';
    } else {
      return 'Português';
    }
  }
}
