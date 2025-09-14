import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_list_item.dart';
import '../widgets/view_state_widget.dart';
import '../../l10n/app_localizations.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Adicionar listener para scroll infinito
    _scrollController.addListener(_onScroll);

    // Buscar personagens ao inicializar a página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterProvider>().fetchCharacters();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      // Quando está próximo do final da lista, carregar mais
      context.read<CharacterProvider>().loadMoreCharacters();
    }
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
              return ViewStateWidget(
                isLoading: provider.isLoading,
                errorMessage: provider.errorMessage,
                onRetry: () => provider.fetchCharacters(),
                isEmpty: provider.characters.isEmpty,
                emptyMessage: l10n.noCharactersFound,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.characters.length +
                      (provider.isLoadMoreRunning ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Se é o último item e está carregando mais, mostrar loading
                    if (index == provider.characters.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final character = provider.characters[index];
                    return CharacterListItem(
                      character: character,
                      index: index,
                    );
                  },
                ),
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
