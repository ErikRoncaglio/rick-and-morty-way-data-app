import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_list_item.dart';
import '../../l10n/app_localizations.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  @override
  void initState() {
    super.initState();
    // Buscar personagens ao inicializar a página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterProvider>().fetchCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Filtros com ChoiceChips
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Consumer<CharacterProvider>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: l10n.all,
                      value: null,
                      selectedValue: provider.selectedStatus,
                      onSelected: () => provider.filterCharacters(null),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: l10n.alive,
                      value: 'alive',
                      selectedValue: provider.selectedStatus,
                      onSelected: () => provider.filterCharacters('alive'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: l10n.dead,
                      value: 'dead',
                      selectedValue: provider.selectedStatus,
                      onSelected: () => provider.filterCharacters('dead'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: l10n.unknown,
                      value: 'unknown',
                      selectedValue: provider.selectedStatus,
                      onSelected: () => provider.filterCharacters('unknown'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Lista de personagens
        Expanded(
          child: Consumer<CharacterProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }

              if (provider.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.errorLoadingCharacters,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => provider.fetchCharacters(),
                        child: Text(l10n.tryAgain),
                      ),
                    ],
                  ),
                );
              }

              if (provider.characters.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noCharactersFound,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }

              return ListView.builder(
                itemCount: provider.characters.length,
                itemBuilder: (context, index) {
                  final character = provider.characters[index];
                  return CharacterListItem(
                    character: character,
                    index: index,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String? value,
    required String? selectedValue,
    required VoidCallback onSelected,
  }) {
    final isSelected = selectedValue == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      side: BorderSide(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
