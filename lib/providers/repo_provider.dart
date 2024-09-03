import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:github_starts_app/services/network_connectivity_service.dart';
import 'package:github_starts_app/services/sqflite_services.dart';
import 'package:github_starts_app/utils/constants/ui_constants.dart';
import 'package:github_starts_app/view/widgets/messenger.dart';
import '../models/repo_model.dart';
import '../services/top_starred_repository_api_service.dart';

class TopStarredReposProvider with ChangeNotifier {
  final TopStarredRepositoryApiService _apiController =
      TopStarredRepositoryApiService();
  final List<RepoModel> _repositories = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoading = false;
  bool _hasMoreLoading = false;
  bool get hasMoreLoading => _hasMoreLoading;
  List<RepoModel> get repositories => _repositories;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  Future<void> fetchInitialRepo() async {
    _changeLoadingState(true);
    if (!await NetworkConnectivityService().checkConnectivity()) {
      Messenger.showSnackBar(
          message: 'You are offline. Showing cached repositories.',
          color: kWarning);
      final repos = await _databaseHelper.getCachedRepositories(20);
      _repositories.addAll(repos);
      log('we have this much from cache ${repos.length}');
      return _changeLoadingState(false);
    }
   _repositories.clear();
    await fetchTopStarredGitHubRepos(isFirst: true);
    _changeLoadingState(false);
  }

  Future<void> fetchMoreOnLoad() async {
    if (_isLoading || !_hasMoreData) return;
    if (!await NetworkConnectivityService().checkConnectivity()) {
      return;
    } else if (_currentPage == 1) {
      _repositories.clear();
      return fetchInitialRepo();
    }
    _hasMoreLoading = true;
    notifyListeners();
    await fetchTopStarredGitHubRepos();
    _hasMoreLoading = false;
    notifyListeners();
  }

  Future<void> fetchTopStarredGitHubRepos(
      {int? page, bool isFirst = false}) async {
    try {
      final int pageToFetch = page ?? _currentPage;
      final repos = await _apiController.fetchRepositories(pageToFetch);
      await _databaseHelper.cacheRepositories(repos, isClear: isFirst);
      if (repos.isEmpty) {
        _hasMoreData = false;
      } else {
        _repositories.addAll(repos);
        _currentPage = pageToFetch + 1;
      }
    } catch (_) {
    } finally {
      log('our total repos are${_repositories.length}');
    }
  }

  void _changeLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
