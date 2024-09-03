

import 'package:flutter/material.dart';
import '../controllers/api_controllers.dart';
import '../models/repo_model.dart';

class TopStarredReposProvider with ChangeNotifier {
  final TopStarredRepositoryApiController _apiController =
      TopStarredRepositoryApiController();
  final List<RepoModel> _repositories = [];
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoading = false;

  List<RepoModel> get repositories => _repositories;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  Future<void> fetchRepositories({int? page}) async {
    if (_isLoading || !_hasMoreData) return;

    _isLoading = true;
    notifyListeners();

    try {
      final int pageToFetch = page ?? _currentPage;
      final repos = await _apiController.fetchRepositories(pageToFetch);

      if (repos.isEmpty) {
        _hasMoreData = false;
      } else {
        _repositories.addAll(repos);
        _currentPage = pageToFetch + 1;
      }
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
