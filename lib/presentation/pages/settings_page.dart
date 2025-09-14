import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../../l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Seção de Tema
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.palette,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.theme,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<ThemeMode>(
                        segments: [
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            label: Text(l10n.themeSystem),
                            icon: const Icon(Icons.brightness_auto),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            label: Text(l10n.themeLight),
                            icon: const Icon(Icons.light_mode),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            label: Text(l10n.themeDark),
                            icon: const Icon(Icons.dark_mode),
                          ),
                        ],
                        selected: {settingsProvider.themeMode},
                        onSelectionChanged: (Set<ThemeMode> selected) {
                          settingsProvider.setThemeMode(selected.first);
                        },
                        showSelectedIcon: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Seção de Idioma
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.language,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.language,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<Locale>(
                        segments: [
                          ButtonSegment<Locale>(
                            value: const Locale('pt', 'BR'),
                            label: Text(l10n.languagePortuguese),
                            icon: const Icon(Icons.flag),
                          ),
                          ButtonSegment<Locale>(
                            value: const Locale('en', 'US'),
                            label: Text(l10n.languageEnglish),
                            icon: const Icon(Icons.flag_outlined),
                          ),
                        ],
                        selected: {settingsProvider.locale},
                        onSelectionChanged: (Set<Locale> selected) {
                          settingsProvider.setLocale(selected.first);
                        },
                        showSelectedIcon: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Card informativo
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.settingsDescription,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
