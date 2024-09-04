// test_data.dart
import 'package:github_starts_app/models/repo_model.dart';

class TestData {
  // Centralized Values
  static const String avatarUrl1 = 'https://example.com/avatar1.png';
  static const String avatarUrl2 = 'https://example.com/avatar2.png';
  static const String description1 = 'description1';
  static const String description2 = 'description2';

  static const String repoName1 = 'repo1';
  static const String repoName2 = 'repo2';

  static const String ownerName1 = 'owner1';
  static const String ownerName2 = 'owner2';

  static const int starsRepo1 = 20;
  static const int starsRepo2 = 10;

  // API Response Data
  static const Map<String, dynamic> topStarredRepoResponse = {
    'items': [
      {
        'id': 1,
        'name': repoName1,
        'description': description1,
        'stargazers_count': starsRepo1,
        'owner': {
          'login': ownerName1,
          'avatar_url': avatarUrl1
        }
      },
      {
        'id': 2,
        'name': repoName2,
        'description': description2,
        'stargazers_count': starsRepo2,
        'owner': {
          'login': ownerName2,
          'avatar_url': avatarUrl2
        }
      }
    ]
  };

  static Map<String, dynamic> singleRepoJsonFromApi([bool wantDesc = true]) {
    return {
      'id': 1,
      'name': repoName1,
      'description': wantDesc ? description1 : null,
      'stargazers_count': starsRepo1,
      'owner': {
        'login': ownerName1,
        'avatar_url': avatarUrl1
      }
    };
  }

  // SQLite Map Data
  static const Map<String, dynamic> singleRepoMapDataFromSqFlite = {
    'id': 1,
    'name': repoName1,
    'ownerName': ownerName1,
    'ownerAvatarUrl': avatarUrl1,
    'stars': starsRepo1,
    'description': description1
  };

  // RepoModels
  static const RepoModel repo1 = RepoModel(
    id: 1,
    name: repoName1,
    ownerName: ownerName1,
    ownerAvatarUrl: avatarUrl1,
    stars: starsRepo1,
    description: description1
  );

  static const RepoModel repo2 = RepoModel(
    id: 2,
    name: repoName2,
    ownerName: ownerName2,
    ownerAvatarUrl: avatarUrl2,
    stars: starsRepo2,
    description: description2
  );
}
