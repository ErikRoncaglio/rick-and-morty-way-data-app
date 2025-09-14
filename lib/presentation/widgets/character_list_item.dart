import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/character_entity.dart';
import '../../l10n/app_localizations.dart';
import '../pages/character_detail_page.dart';

class CharacterListItem extends StatelessWidget {
  final CharacterEntity character;
  final int index;

  const CharacterListItem({
    super.key,
    required this.character,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterDetailPage(character: character),
            ),
          );
        },
        child: ListTile(
          leading: Hero(
            tag: 'hero-character-${character.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                character.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
              ),
            ),
          ),
          title: Text(
            character.name,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: _getStatusColor(character.status),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getLocalizedStatus(character.status, l10n),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${l10n.species}: ${character.species}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          isThreeLine: true,
        ),
      ),
    ).animate().fadeIn(delay: 60.ms).slideX(begin: 0.1, delay: 60.ms);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      case 'unknown':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getLocalizedStatus(String status, AppLocalizations l10n) {
    switch (status.toLowerCase()) {
      case 'alive':
        return l10n.alive;
      case 'dead':
        return l10n.dead;
      case 'unknown':
        return l10n.unknown;
      default:
        return status;
    }
  }
}
