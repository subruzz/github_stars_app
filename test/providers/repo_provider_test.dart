import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_starts_app/providers/repo_provider.dart';
import 'package:github_starts_app/utils/exceptions/main_exception.dart';
import 'package:mockito/mockito.dart';
import 'package:github_starts_app/services/network_connectivity_service.dart';
import 'package:github_starts_app/models/repo_model.dart';
import '../test_utils/classes/mock_classes.mocks.dart';

void main() {
  late MockTopStarredRepositoryApiService mockApiService;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockConnectivity mockConnectivity;
  late NetworkConnectivityService networkConnectivityService;
  late TopStarredReposProvider provider;

  setUp(() {
    // Initialize the mocks
    mockApiService = MockTopStarredRepositoryApiService();
    mockDatabaseHelper = MockDatabaseHelper();
    mockConnectivity = MockConnectivity();

    // Create the NetworkConnectivityService with the mocked Connectivity instance
    networkConnectivityService =
        NetworkConnectivityService(connectivity: mockConnectivity);

    // Create the provider with the mocked services
    provider = TopStarredReposProvider(
      networkConnectivityService: networkConnectivityService,
      apiController: mockApiService,
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('TopStarredReposProvider', () {
    test('fetchInitialRepo should fetch repositories from API if online',
        () async {
      // Arrange
      final List<RepoModel> mockRepos = [
        const RepoModel(
            id: 1,
            name: 'Repo 1',
            ownerName: 'Owner 1',
            ownerAvatarUrl: 'https://example.com/avatar1.png',
            stars: 10,
            description: 'Description')
      ];
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockApiService.fetchRepositories(1))
          .thenAnswer((_) async => mockRepos);

      // Act
      await provider.fetchInitialRepo();

      // Assert
      expect(provider.repositories, mockRepos);
      expect(provider.hasError, false);
      expect(provider.hasMoreData, true);
      verify(mockApiService.fetchRepositories(1)).called(1);
    });

    test('fetchInitialRepo should load repositories from cache if offline',
        () async {
      // Arrange
      final List<RepoModel> mockRepos = [
        const RepoModel(
            id: 1,
            name: 'Repo 1',
            ownerName: 'Owner 1',
            ownerAvatarUrl: 'https://example.com/avatar1.png',
            stars: 10,
            description: 'Description')
      ];
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);
      when(mockDatabaseHelper.getCachedRepositories(20))
          .thenAnswer((_) async => mockRepos);

      // Act
      await provider.fetchInitialRepo();

      // Assert
      expect(provider.repositories, mockRepos);
      expect(provider.hasError, false);
      expect(provider.hasMoreData, false);
      verify(mockDatabaseHelper.getCachedRepositories(20)).called(1);
    });

    test(
        'fetchMoreOnLoad should fetch more repositories if online and more data is available',
        () async {
      // Arrange
      final List<RepoModel> initialRepos = [
        const RepoModel(
            id: 1,
            name: 'Repo 1',
            ownerName: 'Owner 1',
            ownerAvatarUrl: 'https://example.com/avatar1.png',
            stars: 10,
            description: 'Description')
      ];
      final List<RepoModel> moreRepos = [
        const RepoModel(
            id: 2,
            name: 'Repo 2',
            ownerName: 'Owner 2',
            ownerAvatarUrl: 'https://example.com/avatar2.png',
            stars: 20,
            description: 'Description')
      ];
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockApiService.fetchRepositories(2))
          .thenAnswer((_) async => moreRepos);

      // Initialize provider state
      provider.repositories.addAll(initialRepos);
      await provider.fetchInitialRepo(); // Populate initial data

      // Act
      await provider.fetchMoreOnLoad();

      // Assert
      expect(provider.repositories.length,
          2); // Assumes initialRepos and moreRepos are appended
      expect(provider.hasMoreData, true);
      verify(mockApiService.fetchRepositories(2)).called(1);
    });

    test('fetchTopStarredGitHubRepos should handle API errors correctly',
        () async {
      // Arrange
      when(mockApiService.fetchRepositories(1))
          .thenThrow(MainException('API error'));

      // Act
      await provider.fetchTopStarredGitHubRepos(isFirst: true);

      // Assert
      expect(provider.hasError, true);
      expect(provider.hasMoreData, false);
    });
  });
}
