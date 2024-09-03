
import 'package:dio/dio.dart';
import '../models/repo_model.dart';

class TopStarredRepositoryApiController {
  final Dio _dio = Dio();

  Future<List<RepoModel>> fetchRepositories(int page) async {
    try {
      final response = await _dio.get(
        'https://api.github.com/search/repositories',
        queryParameters: {
          'q': 'created:>2024-07-06',
          'sort': 'stars',
          'order': 'desc',
          'page': page,
          'per_page': '20',
        },
      );

      final List<dynamic> data = response.data['items'];

      return data.map((repo) => RepoModel.fromJson(repo)).toList();
    } catch (e) {
      throw Exception('Failed to load repositories');
    }
  }
}
