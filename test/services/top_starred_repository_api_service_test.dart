import 'package:flutter_test/flutter_test.dart';
import 'package:github_starts_app/utils/exceptions/main_exception.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:github_starts_app/services/top_starred_repository_api_service.dart';
import 'package:github_starts_app/models/repo_model.dart';

import '../test_utils/classes/mock_classes.mocks.dart';
import '../test_utils/data/test_data.dart';

void main() {
  late TopStarredRepositoryApiService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = TopStarredRepositoryApiService(dio: mockDio);
  });

  group('Get top starred repo in the last 30 days', () {
    test(
        'fetchRepositories returns a list of repositories when the HTTP call completes successfully',
        () async {
      // Arrange

      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: TestData.topStarredRepoResponse,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act
      final repos = await apiService.fetchRepositories(1);

      // Assert
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
      final response = {'items': []};

      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: response,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act
      final repos = await apiService.fetchRepositories(1);

      // Assert
      expect(repos, isEmpty);
    });

    test('fetchRepositories throws DioException on network error', () async {
      // Arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
        error: 'Network Error',
      ));

      // Act & Assert
      expect(() async => await apiService.fetchRepositories(1),
          throwsA(isA<MainException>()));
    });

    test(
        'fetchRepositories throws MainException when response status is not 200',
        () async {
      // Arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 500,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act & Assert
      expect(() async => await apiService.fetchRepositories(1),
          throwsA(isA<MainException>()));
    });
  });
}
