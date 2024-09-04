import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:github_starts_app/providers/repo_provider.dart';
import 'package:github_starts_app/utils/exceptions/main_exception.dart';
import '../test_utils/classes/mock_classes.dart';
import '../test_utils/data/test_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockTopStarredRepositoryApiService mockApiService;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockNetworkConnectivityService mockNetworkConnectivityService;
  late TopStarredReposProvider provider;

  setUp(() {
    mockApiService = MockTopStarredRepositoryApiService();
    mockDatabaseHelper = MockDatabaseHelper();
    mockNetworkConnectivityService = MockNetworkConnectivityService();

    provider = TopStarredReposProvider(
      networkConnectivityService: mockNetworkConnectivityService,
      apiController: mockApiService,
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('TopStarredReposProvider', () {
    test('Initial state should be correct', () {
      expect(provider.repositories, []);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
      expect(provider.hasMoreData, true);
    });

    test('get repos using the api', () async {
      // Arrange
      when(() => mockNetworkConnectivityService.checkifNetworkAvailable())
          .thenAnswer((_) async => true);
      when(() => mockApiService.fetchRepositories(1))
          .thenAnswer((_) async => []);
      // Mock database caching
      when(() => mockDatabaseHelper.cacheRepositories(any(), isClear: true))
          .thenAnswer((_) async {});
      // Act
      await provider.fetchInitialRepo();

      // Assert
      verify(() => mockApiService.fetchRepositories(1)).called(1);
    });

    test('Fetch initial repo successfully', () async {
      // Arrange
      final repos = [TestData.repo1, TestData.repo2];

      // Mock network availability
      when(() => mockNetworkConnectivityService.checkifNetworkAvailable())
          .thenAnswer((_) async => true);

      // Mock API response
      when(() => mockApiService.fetchRepositories(1))
          .thenAnswer((_) async => repos);

      // Mock database caching
      when(() => mockDatabaseHelper.cacheRepositories(any(), isClear: true))
          .thenAnswer((_) async {});

      // Act
      await provider.fetchInitialRepo();

      // Assert
      expect(provider.repositories, repos);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
      expect(provider.hasMoreData, true);

      // Verify database caching
      verify(() => mockDatabaseHelper.cacheRepositories(repos, isClear: true))
          .called(1);
    });

    test('Fetch initial repo offline', () async {
      // Arrange
      when(() => mockNetworkConnectivityService.checkifNetworkAvailable())
          .thenAnswer((_) async => false);
      final repos = [TestData.repo1, TestData.repo2];
      when(() => mockDatabaseHelper.getCachedRepositories(any()))
          .thenAnswer((_) async => repos);

      // Act
      await provider.fetchInitialRepo();

      // Assert
      expect(provider.repositories, repos);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
      expect(provider.hasMoreData, false);
    });

    test('Fetch repo handles error', () async {
      // Arrange
      when(() => mockApiService.fetchRepositories(any()))
          .thenThrow(MainException('Error'));

      // Act
      await provider.fetchTopStarredGitHubRepos();

      // Assert
      expect(provider.hasError, true);
      expect(provider.isLoading, false);
      expect(provider.hasMoreData, false);
    });

    test('Fetch more data successfully', () async {
      // Arrange
      final repos = [TestData.repo1, TestData.repo2];
      when(() => mockNetworkConnectivityService.checkifNetworkAvailable())
          .thenAnswer((_) async => true);
      when(() => mockApiService.fetchRepositories(any()))
          .thenAnswer((_) async => repos);
      when(() => mockDatabaseHelper.cacheRepositories(any(), isClear: false))
          .thenAnswer((_) async {});

      // Act
      await provider.fetchMoreOnLoad();

      // Assert
      expect(provider.repositories, repos); // Check if repositories are updated
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
      expect(provider.hasMoreData, true); // Ensure hasMoreData is set correctly
    });

    test('Fetch more data handles error', () async {
      // Arrange
      when(() => mockNetworkConnectivityService.checkifNetworkAvailable())
          .thenAnswer((_) async => true);
      when(() => mockApiService.fetchRepositories(any()))
          .thenThrow(MainException('Error'));

      // Act
      await provider.fetchMoreOnLoad();

      // Assert
      expect(provider.hasError, true);
      expect(provider.isLoading, false);
      expect(provider.hasMoreData, false); // Ensure hasMoreData is updated
    });
  });
}
