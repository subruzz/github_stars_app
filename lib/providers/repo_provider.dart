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
  String? _hasError;

  TopStarredReposProvider({
    required NetworkConnectivityService networkConnectivityService,
    required TopStarredRepositoryApiService apiController,
    required DatabaseHelper databaseHelper,
  })  : _apiController = apiController,
        _networkConnectivityService = networkConnectivityService,
        _databaseHelper = databaseHelper;

  // Getters for the provider's state
  String? get hasError => _hasError;
  List<RepoModel> get repositories => _repositories;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  // Set the loading state and notify listeners
  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  // Set the error message
  void _setError(String? error) {
    _hasError = error;
    notifyListeners();
  }

  // Fetch initial repositories (first page)
  Future<void> fetchInitialRepo() async {
    _setError(null); // Reset error state
    _setLoadingState(true);

    // Check network connectivity
    bool isConnected =
        await _networkConnectivityService.checkifNetworkAvailable();
    log('Network connection status: $isConnected');

    if (!isConnected) {
      // Offline: Load from cache
      _setError('You are offline. Showing cached repositories.');
      final repos = await _databaseHelper.getCachedRepositories(20);
      _repositories.clear(); // Clear old data
      _repositories.addAll(repos);
      _hasMoreData = false;
      log('Loaded ${repos.length} repositories from cache');
    } else {
      // Online: Fetch fresh data
      _currentPage = 1;
      _repositories.clear();
      await fetchTopStarredGitHubRepos(isFirst: true);
    }

    _setLoadingState(false);
  }

  // Fetch more repositories on scroll
  Future<void> fetchMoreOnLoad() async {
    if (_isLoading || !_hasMoreData) return;

    if (!await _networkConnectivityService.checkifNetworkAvailable()) {
      _hasMoreData = false;
      _setError('You are offline. No more repositories available.');
      return;
    } else if (_currentPage == 1) {
      _hasMoreData = true;
      return fetchInitialRepo();
    }
    await fetchTopStarredGitHubRepos();
  }

  // Main API call to fetch repositories
  Future<void> fetchTopStarredGitHubRepos(
      {int? page, bool isFirst = false}) async {
    _setError(null); // Reset error state before each fetch

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

      // Cache repositories if required
      await _databaseHelper.cacheRepositories(repos, isClear: isFirst);
    } on MainException catch (error) {
      _setError('${error.message}, Please try rereshing');
      _hasMoreData = false;
      log('MainException: $error');
    } catch (e) {
      _setError('An unexpected error occurred.');
      log('Error: $e');
    } finally {
      log('Total repositories: ${_repositories.length}');
      notifyListeners();
    }
  }
}
