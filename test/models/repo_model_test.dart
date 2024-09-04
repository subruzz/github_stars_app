import 'package:flutter_test/flutter_test.dart';
import 'package:github_starts_app/models/repo_model.dart';
import '../test_utils/data/test_data.dart';

void main() {
  group('RepoModel Tests', () {
    test('fromJson correctly parses JSON into RepoModel', () {
      final repo = RepoModel.fromJson(TestData.singleRepoJsonFromApi());

      expect(repo.id, 1);
      expect(repo.name, TestData.repoName1);
      expect(repo.description, TestData.description1);
      expect(repo.stars, TestData.starsRepo1);
      expect(repo.ownerName, TestData.ownerName1);
      expect(repo.ownerAvatarUrl, TestData.avatarUrl1);
    });

    test('fromJson handles missing description field', () {
      final repo = RepoModel.fromJson(TestData.singleRepoJsonFromApi(false));

      expect(repo.description, 'No description available');
    });

    test('fromMap correctly parses a Map into RepoModel', () {
      final repo = RepoModel.fromMap(TestData.singleRepoMapDataFromSqFlite);

      expect(repo.id, 1);
      expect(repo.name, TestData.repoName1);
      expect(repo.ownerName, TestData.ownerName1);
      expect(repo.ownerAvatarUrl, TestData.avatarUrl1);
      expect(repo.stars, TestData.starsRepo1);
      expect(repo.description, TestData.description1);
    });

    test('toMap correctly converts RepoModel to a Map', () {
      final map = TestData.repo1.toMap();

      expect(map['id'], TestData.repo1.id);
      expect(map['name'], TestData.repo1.name);
      expect(map['ownerName'], TestData.repo1.ownerName);
      expect(map['ownerAvatarUrl'], TestData.repo1.ownerAvatarUrl);
      expect(map['stars'], TestData.repo1.stars);
      expect(map['description'], TestData.repo1.description);
    });

    test('fromJson handles null fields correctly', () {
      final json = {
        'id': 1,
        'name': 'repo1',
        'description': null,
        'stargazers_count': 10,
        'owner': {
          'login': 'owner1',
          'avatar_url': 'https://example.com/avatar1.png'
        }
      };

      final repo = RepoModel.fromJson(json);

      expect(repo.description, 'No description available');
    });
  });
}
