import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:github_starts_app/services/network_connectivity_service.dart';
import 'package:github_starts_app/services/sqflite_services.dart';
import 'package:github_starts_app/utils/exceptions/main_exception.dart';
import '../models/repo_model.dart';
import '../services/top_starred_repository_api_service.dart';

class TopStarredReposProvider with ChangeNotifier {
  final TopStarredRepositoryApiService _apiController;
  final DatabaseHelper _databaseHelper;
  final List<RepoModel> _repositories = [];
  final NetworkConnectivityService _networkConnectivityService;
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoading = false;
  bool _hasError = false;

  TopStarredReposProvider({
    required NetworkConnectivityService networkConnectivityService,
    required TopStarredRepositoryApiService apiController,
    required DatabaseHelper databaseHelper,
  })  : _apiController = apiController,
        _networkConnectivityService = networkConnectivityService,
        _databaseHelper = databaseHelper;

  bool get hasError => _hasError;
  List<RepoModel> get repositories => _repositories;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  Future<void> fetchInitialRepo() async {
    _changeLoadingState(true);

    // Check network connectivity
    bool isConnected =
        await _networkConnectivityService.checkifNetworkAvailable();
    log('we have connection: $isConnected');

    if (!isConnected) {
      // Offline scenario
      // Messenger.showSnackBar(
      //   message: 'You are offline. Showing cached repositories.',
      //   color: kWarning,
      // );

      // Get cached repositories
      final repos = await _databaseHelper.getCachedRepositories(20);
      _repositories.clear(); // Ensure previous data is cleared
      _repositories.addAll(repos);
      log('Loaded ${repos.length} repositories from cache');

      // No more data available from cache
      _hasMoreData = false;
    } else {
      // Online scenario
      // Clear current repositories and fetch new data
      _currentPage = 1;
      _repositories.clear();
      await fetchTopStarredGitHubRepos(isFirst: true);
    }

    _changeLoadingState(false);
  }

  Future<void> fetchMoreOnLoad() async {
    if (_isLoading || !_hasMoreData) return;

    if (!await _networkConnectivityService.checkifNetworkAvailable()) {
      _hasMoreData = false;

      notifyListeners();
      return;
    }

    notifyListeners();
    await fetchTopStarredGitHubRepos();

    notifyListeners();
  }

  Future<void> fetchTopStarredGitHubRepos(
      {int? page, bool isFirst = false}) async {
    try {
      final int pageToFetch = page ?? _currentPage;
      final repos = await _apiController.fetchRepositories(pageToFetch);

      if (repos.isEmpty) {
        _hasMoreData = false;
      } else {
        _repositories.addAll(repos);
        _currentPage = pageToFetch + 1;
        _hasMoreData = true;
      }

      await _databaseHelper.cacheRepositories(repos, isClear: isFirst);
    } on MainException catch (error) {
      _hasError = true;
      _hasMoreData = false;

      log('Error fetching repositories: $error');
    } catch (e) {
      _hasError = true; // Set error flag to true if any exception occurs
      print('Error fetching repositories: $e');
    } finally {
      log('Total repositories: ${_repositories.length}');
      notifyListeners();
    }
  }

  void _changeLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
