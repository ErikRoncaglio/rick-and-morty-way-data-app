import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_and_morty_way_data_app/domain/entities/character_entity.dart';
import 'package:rick_and_morty_way_data_app/presentation/providers/character_provider.dart';

import '../../domain/usecases/mock_usecases.mocks.dart';

void main() {
  late MockGetAllCharacters mockGetAllCharacters;
  late CharacterProvider characterProvider;

  setUp(() {
    mockGetAllCharacters = MockGetAllCharacters();
    characterProvider = CharacterProvider(mockGetAllCharacters);
  });

  group('CharacterProvider - fetchCharacters', () {
    test('deve carregar personagens com sucesso', () async {
      // Arrange
      final mockCharacters = [
        CharacterEntity(
          id: 1,
          name: 'Rick Sanchez',
          status: 'Alive',
          species: 'Human',
          image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        ),
        CharacterEntity(
          id: 2,
          name: 'Morty Smith',
          status: 'Alive',
          species: 'Human',
          image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
        ),
      ];

      final mockResponse = {
        'results': mockCharacters,
        'info': {
          'count': 826,
          'pages': 42,
          'next': 'https://rickandmortyapi.com/api/character?page=2',
          'prev': null,
        }
      };

      when(mockGetAllCharacters(page: 1, status: null))
          .thenAnswer((_) async => mockResponse);

      // Act
      await characterProvider.fetchCharacters();

      // Assert
      expect(characterProvider.isLoading, false);
      expect(characterProvider.characters, mockCharacters);
      expect(characterProvider.currentPage, 1);
      expect(characterProvider.hasNextPage, true);
      expect(characterProvider.errorMessage, null);
    });

    test('deve lidar com erros ao carregar personagens', () async {
      // Arrange
      when(mockGetAllCharacters(page: 1, status: null))
          .thenThrow(Exception('Erro de conexão'));

      // Act
      await characterProvider.fetchCharacters();

      // Assert
      expect(characterProvider.isLoading, false);
      expect(characterProvider.characters, isEmpty);
      expect(characterProvider.errorMessage, isNotNull);
      expect(characterProvider.errorMessage, contains('Erro ao carregar personagens'));
    });

    test('deve resetar estado ao iniciar nova busca', () async {
      // Arrange
      final mockResponse = {
        'results': <CharacterEntity>[],
        'info': {
          'count': 0,
          'pages': 1,
          'next': null,
          'prev': null,
        }
      };

      when(mockGetAllCharacters(page: anyNamed('page'), status: anyNamed('status')))
          .thenAnswer((_) async => mockResponse);

      // Primeiro, simular um estado com dados
      await characterProvider.fetchCharacters();

      // Act - Nova busca deve resetar o estado
      await characterProvider.fetchCharacters();

      // Assert
      expect(characterProvider.currentPage, 1);
      expect(characterProvider.errorMessage, null);
    });
  });

  group('CharacterProvider - loadMoreCharacters', () {
    test('deve carregar mais personagens com sucesso', () async {
      // Arrange
      final firstPageCharacters = [
        CharacterEntity(
          id: 1,
          name: 'Rick Sanchez',
          status: 'Alive',
          species: 'Human',
          image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        ),
      ];

      final secondPageCharacters = [
        CharacterEntity(
          id: 2,
          name: 'Morty Smith',
          status: 'Alive',
          species: 'Human',
          image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
        ),
      ];

      final firstPageResponse = {
        'results': firstPageCharacters,
        'info': {
          'count': 826,
          'pages': 42,
          'next': 'https://rickandmortyapi.com/api/character?page=2',
          'prev': null,
        }
      };

      final secondPageResponse = {
        'results': secondPageCharacters,
        'info': {
          'count': 826,
          'pages': 42,
          'next': 'https://rickandmortyapi.com/api/character?page=3',
          'prev': 'https://rickandmortyapi.com/api/character?page=1',
        }
      };

      when(mockGetAllCharacters(page: 1, status: null))
          .thenAnswer((_) async => firstPageResponse);
      when(mockGetAllCharacters(page: 2, status: null))
          .thenAnswer((_) async => secondPageResponse);

      // Primeiro carregar a primeira página
      await characterProvider.fetchCharacters();
      final initialLength = characterProvider.characters.length;

      // Act - Carregar mais personagens
      await characterProvider.loadMoreCharacters();

      // Assert
      expect(characterProvider.isLoadMoreRunning, false);
      expect(characterProvider.characters.length, initialLength + secondPageCharacters.length);
      expect(characterProvider.currentPage, 2);
      expect(characterProvider.hasNextPage, true);
    });

    test('não deve carregar mais quando não há próxima página', () async {
      // Arrange
      final mockResponse = {
        'results': <CharacterEntity>[],
        'info': {
          'count': 1,
          'pages': 1,
          'next': null,
          'prev': null,
        }
      };

      when(mockGetAllCharacters(page: 1, status: null))
          .thenAnswer((_) async => mockResponse);

      await characterProvider.fetchCharacters();

      // Act
      await characterProvider.loadMoreCharacters();

      // Assert
      verify(mockGetAllCharacters(page: 1, status: null)).called(1);
      verifyNever(mockGetAllCharacters(page: 2, status: null));
    });

    test('deve lidar com erros ao carregar mais personagens', () async {
      // Arrange
      final firstPageResponse = {
        'results': [
          CharacterEntity(
            id: 1,
            name: 'Rick Sanchez',
            status: 'Alive',
            species: 'Human',
            image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
          ),
        ],
        'info': {
          'count': 826,
          'pages': 42,
          'next': 'https://rickandmortyapi.com/api/character?page=2',
          'prev': null,
        }
      };

      when(mockGetAllCharacters(page: 1, status: null))
          .thenAnswer((_) async => firstPageResponse);
      when(mockGetAllCharacters(page: 2, status: null))
          .thenThrow(Exception('Erro de conexão'));

      await characterProvider.fetchCharacters();
      final initialLength = characterProvider.characters.length;

      // Act
      await characterProvider.loadMoreCharacters();

      // Assert
      expect(characterProvider.isLoadMoreRunning, false);
      expect(characterProvider.characters.length, initialLength); // Lista não deve mudar
      expect(characterProvider.errorMessage, contains('Erro ao carregar mais personagens'));
    });
  });

  group('CharacterProvider - filterCharacters', () {
    test('deve filtrar personagens por status', () async {
      // Arrange
      final aliveCharacters = [
        CharacterEntity(
          id: 1,
          name: 'Rick Sanchez',
          status: 'Alive',
          species: 'Human',
          image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        ),
      ];

      final mockResponse = {
        'results': aliveCharacters,
        'info': {
          'count': 399,
          'pages': 20,
          'next': 'https://rickandmortyapi.com/api/character?page=2&status=alive',
          'prev': null,
        }
      };

      when(mockGetAllCharacters(page: 1, status: 'Alive'))
          .thenAnswer((_) async => mockResponse);

      // Act
      await characterProvider.filterCharacters('Alive');

      // Assert
      expect(characterProvider.characters, aliveCharacters);
      expect(characterProvider.selectedStatus, 'Alive');
      expect(characterProvider.currentPage, 1); // Paginação resetada
      expect(characterProvider.hasNextPage, true);
    });

    test('deve resetar filtro quando status for null', () async {
      // Arrange
      final allCharacters = [
        CharacterEntity(
          id: 1,
          name: 'Rick Sanchez',
          status: 'Alive',
          species: 'Human',
          image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        ),
        CharacterEntity(
          id: 2,
          name: 'Dead Character',
          status: 'Dead',
          species: 'Human',
          image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
        ),
      ];

      final mockResponse = {
        'results': allCharacters,
        'info': {
          'count': 826,
          'pages': 42,
          'next': 'https://rickandmortyapi.com/api/character?page=2',
          'prev': null,
        }
      };

      when(mockGetAllCharacters(page: 1, status: null))
          .thenAnswer((_) async => mockResponse);

      // Act
      await characterProvider.filterCharacters(null);

      // Assert
      expect(characterProvider.characters, allCharacters);
      expect(characterProvider.selectedStatus, null);
      expect(characterProvider.currentPage, 1);
    });
  });

  group('CharacterProvider - Estados', () {
    test('deve inicializar com valores padrão', () {
      // Assert
      expect(characterProvider.isLoading, false);
      expect(characterProvider.characters, isEmpty);
      expect(characterProvider.errorMessage, null);
      expect(characterProvider.selectedStatus, null);
      expect(characterProvider.currentPage, 1);
      expect(characterProvider.hasNextPage, true);
      expect(characterProvider.isLoadMoreRunning, false);
    });

    test('deve atualizar isLoading durante fetchCharacters', () async {
      // Arrange
      bool loadingDuringCall = false;
      when(mockGetAllCharacters(page: 1, status: null))
          .thenAnswer((_) async {
        loadingDuringCall = characterProvider.isLoading;
        return {
          'results': <CharacterEntity>[],
          'info': {'next': null}
        };
      });

      // Act
      await characterProvider.fetchCharacters();

      // Assert
      expect(loadingDuringCall, true);
      expect(characterProvider.isLoading, false);
    });
  });
}
