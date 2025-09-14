import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/episode_provider.dart';
import '../widgets/view_state_widget.dart';
import '../../l10n/app_localizations.dart';

class EpisodeListPage extends StatefulWidget {
  const EpisodeListPage({super.key});

  @override
  State<EpisodeListPage> createState() => _EpisodeListPageState();
}

class _EpisodeListPageState extends State<EpisodeListPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Adicionar listener para scroll infinito
    _scrollController.addListener(_onScroll);

    // Buscar episódios ao inicializar a página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EpisodeProvider>().fetchEpisodes();
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
      context.read<EpisodeProvider>().loadMoreEpisodes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<EpisodeProvider>(
      builder: (context, provider, child) {
        return ViewStateWidget(
          isLoading: provider.isLoading,
          errorMessage: provider.errorMessage,
          onRetry: () => provider.fetchEpisodes(),
          isEmpty: provider.episodes.isEmpty,
          emptyMessage: l10n.noEpisodesFound,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: provider.episodes.length + (provider.isLoadMoreRunning ? 1 : 0),
            itemBuilder: (context, index) {
              // Se é o último item e está carregando mais, mostrar loading
              if (index == provider.episodes.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final episode = provider.episodes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      episode.episode.split('E')[1] ?? '?',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    episode.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.tv,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            episode.episode,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            episode.airDate,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ).animate()
                    .fadeIn(duration: 300.ms, delay: (index * 50).ms)
                    .slideX(begin: 0.2),
              );
            },
          ),
        );
      },
    );
  }
}
