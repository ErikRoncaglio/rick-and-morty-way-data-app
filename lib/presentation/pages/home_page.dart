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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;

    // Inicializar as páginas
    _pages = [
      const CharacterListPage(),
      const LocationListPage(),
      const EpisodeListPage(), // Substituindo o placeholder pela página real
    ];

    // Inicializar os títulos
    _titles = [
      l10n.characters,
      l10n.locations,
      l10n.episodes,
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
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
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }
}
