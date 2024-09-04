import 'package:flutter_test/flutter_test.dart';
import 'package:github_starts_app/utils/exceptions/main_exception.dart';
import 'package:dio/dio.dart';
import 'package:github_starts_app/services/top_starred_repository_api_service.dart';
import 'package:github_starts_app/models/repo_model.dart';
import 'package:mocktail/mocktail.dart';

import '../test_utils/classes/mock_classes.dart';
import '../test_utils/data/test_data.dart';

void main() {
  late TopStarredRepositoryApiService apiService;
  late MockDio mockDio;

  // Initializes the mock objects and the service before each test
  setUp(() {
    mockDio = MockDio(); // Creates a mock instance of Dio
    apiService = TopStarredRepositoryApiService(
        dio: mockDio); // Initializes the service with the mock Dio instance
  });

  group('Get top starred repo in the last 30 days', () {
    test(
        'fetchRepositories returns a list of repositories when the HTTP call completes successfully',
        () async {
      // Arrange
      // Configures the mock Dio instance to return a successful response with test data
      when(() => mockDio.get(captureAny(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: TestData.topStarredRepoResponse,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act
      // Calls the method under test
      final repos = await apiService.fetchRepositories(1);

      // Assert
      // Verifies that the method returns a list of repositories with the expected properties
      expect(repos, isA<List<RepoModel>>());
      expect(repos.length, 2);
      expect(repos[0].id, 1);
      expect(repos[0].name, TestData.repoName1);
      expect(repos[0].ownerName, TestData.ownerName1);
      expect(repos[0].ownerAvatarUrl, TestData.avatarUrl1);
      expect(repos[0].stars, TestData.starsRepo1);
    });

    test(
        'fetchRepositories returns an empty list when the response data is empty',
        () async {
      // Arrange
      // Configures the mock Dio instance to return an empty list response
      final response = {'items': []};

      when(() => mockDio.get(captureAny(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: response,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act
      // Calls the method under test
      final repos = await apiService.fetchRepositories(1);

      // Assert
      // Verifies that the method returns an empty list
      expect(repos, isEmpty);
    });

    test('fetchRepositories throws DioException on network error', () async {
      // Arrange
      // Configures the mock Dio instance to throw a DioException
      when(() => mockDio.get(captureAny(),
              queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
        error: 'Network Error',
      ));

      // Act & Assert
      // Verifies that the method throws a MainException when a network error occurs
      expect(() async => await apiService.fetchRepositories(1),
          throwsA(isA<MainException>()));
    });

    test(
        'fetchRepositories throws MainException when response status is not 200',
        () async {
      // Arrange
      // Configures the mock Dio instance to return an unsuccessful response
      when(() => mockDio.get(captureAny(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 500,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act & Assert
      // Verifies that the method throws a MainException when the HTTP response status is not 200
      expect(() async => await apiService.fetchRepositories(1),
          throwsA(isA<MainException>()));
    });
  });
}
