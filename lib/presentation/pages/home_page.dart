import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'character_list_page.dart';
import 'episode_list_page.dart';
import 'location_list_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;
  late final List<String> _titles;

  // Para garantir que a inicialização só ocorra uma vez
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Esta verificação garante que o código só rode na primeira vez
    if (!_isInitialized) {
      final l10n = AppLocalizations.of(context)!;

      // Inicializar as páginas
      _pages = [
        const CharacterListPage(),
        const LocationListPage(),
        const EpisodeListPage(),
      ];

      // Inicializar os títulos
      _titles = [l10n.characters, l10n.locations, l10n.episodes];

      _isInitialized = true;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Para garantir que os títulos sejam atualizados ao trocar de idioma
    final l10n = AppLocalizations.of(context)!;
    final currentTitles = [l10n.characters, l10n.locations, l10n.episodes];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTitles[_selectedIndex]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: l10n.characters,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.location_on),
            label: l10n.locations,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.play_circle_outline),
            label: l10n.episodes,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }
}
