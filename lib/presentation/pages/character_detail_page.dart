import 'package:flutter/material.dart';
import '../../domain/entities/character_entity.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/detail_info_row.dart';

class CharacterDetailPage extends StatelessWidget {
  final CharacterEntity character;

  const CharacterDetailPage({super.key, required this.character});

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return '🟢';
      case 'dead':
        return '🔴';
      default:
        return '🟡';
    }
  }

  String _getGenderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return '♂️';
      case 'female':
        return '♀️';
      case 'genderless':
        return '⚪';
      default:
        return '❓';
    }
  }

  String _getStatusText(String status, AppLocalizations l10n) {
    switch (status.toLowerCase()) {
      case 'alive':
        return l10n.alive;
      case 'dead':
        return l10n.dead;
      default:
        return l10n.unknown;
    }
  }

  String _getGenderText(String gender, AppLocalizations l10n) {
    switch (gender.toLowerCase()) {
      case 'male':
        return l10n.male;
      case 'female':
        return l10n.female;
      case 'genderless':
        return l10n.genderless;
      default:
        return l10n.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.characterDetails)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.surface,
                    theme.colorScheme.surface.withOpacity(0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Character Image
                    Hero(
                      tag: 'hero-character-${character.id}',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.shadow.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            character.image,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 80,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Character Name
                    Text(
                      character.name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: character.status.toLowerCase() == 'alive'
                            ? Colors.green.withOpacity(0.2)
                            : character.status.toLowerCase() == 'dead'
                            ? Colors.red.withOpacity(0.2)
                            : Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: character.status.toLowerCase() == 'alive'
                              ? Colors.green
                              : character.status.toLowerCase() == 'dead'
                              ? Colors.red
                              : Colors.orange,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getStatusIcon(character.status),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getStatusText(character.status, l10n),
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: character.status.toLowerCase() == 'alive'
                                  ? Colors.green.shade700
                                  : character.status.toLowerCase() == 'dead'
                                  ? Colors.red.shade700
                                  : Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Character Information Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.generalInformation,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      DetailInfoRow(
                        label: l10n.status,
                        value:
                            '${_getStatusIcon(character.status)} ${_getStatusText(character.status, l10n)}',
                        icon: Icons.health_and_safety,
                      ),

                      DetailInfoRow(
                        label: l10n.species,
                        value: character.species,
                        icon: Icons.pets,
                      ),

                      DetailInfoRow(
                        label: l10n.gender,
                        value:
                            '${_getGenderIcon(character.gender)} ${_getGenderText(character.gender, l10n)}',
                        icon: Icons.person_outline,
                      ),

                      DetailInfoRow(
                        label: l10n.origin,
                        value: character.originName.isEmpty
                            ? l10n.unknown
                            : character.originName,
                        icon: Icons.home,
                      ),

                      DetailInfoRow(
                        label: l10n.lastKnownLocation,
                        value: character.lastKnownLocation.isEmpty
                            ? l10n.unknown
                            : character.lastKnownLocation,
                        icon: Icons.location_on,
                      ),

                      DetailInfoRow(
                        label: l10n.episodeCount,
                        value:
                            '${character.episodeCount} ${character.episodeCount == 1 ? 'episódio' : 'episódios'}',
                        icon: Icons.tv,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
