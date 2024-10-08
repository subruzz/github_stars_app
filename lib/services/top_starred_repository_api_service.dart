// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:github_starts_app/utils/exceptions/main_exception.dart';

import 'package:github_starts_app/utils/extensions/formatted_time.dart';

import '../models/repo_model.dart';

/// Controller class responsible for interacting with the GitHub API
/// to fetch the top-starred repositories created in the last 30 days.
class TopStarredRepositoryApiService {
  final Dio dio;
  TopStarredRepositoryApiService({
    required this.dio,
  });
  // Dio instance for making HTTP requests

  /// Fetches a list of repositories created in the last 30 days,
  /// sorted by stars in descending order.
  ///
  /// [page] is the page number for paginated results.
  /// Returns a list of [RepoModel] containing repository data.
  Future<List<RepoModel>> fetchRepositories(int page) async {
    try {
      // Calculate the date 30 days ago from the current date
      final DateTime thirtyDaysAgo =
          DateTime.now().subtract(const Duration(days: 30));
      // Format the date to 'yyyy-MM-dd' format using the custom extension
      final String formattedDate = thirtyDaysAgo.toFormattedString();
      log('current date is $formattedDate');
      // Make the GET request to GitHub API
      final response = await dio.get(
        'https://api.github.com/search/repositories',
        queryParameters: {
          'q':
              'created:>$formattedDate', // Filter repositories created in the last 30 days
          'sort': 'stars', // Sort by stars
          'order': 'desc', // Order in descending order
          'page': page, // Page number for pagination
          'per_page': '20', // Number of results per page
        },
      );

      if (response.statusCode == 200) {
        // Extract repository items from the response data
        final List<dynamic> data = response.data['items'];

        // Map the response data to a list of RepoModel
        return data.map((repo) => RepoModel.fromJson(repo)).toList();
      } else {
        throw MainException('Failed to load repositories');
      }
    } catch (e) {
      // Throw an MainException  if the API call fails
      throw MainException('Failed to load repositories');
    }
  }
}
