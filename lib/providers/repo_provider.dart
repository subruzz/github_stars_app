import 'package:flutter/material.dart';
import '../controllers/api_controllers.dart';
import '../models/repo_model.dart';

class TopStarredReposProvider with ChangeNotifier {
  final TopStarredRepositoryApiController _apiController =
      TopStarredRepositoryApiController();
  final List<RepoModel> _repositories = [];
  bool _isLoading = false;

  List<RepoModel> get repositories => _repositories;
  bool get isLoading => _isLoading;

  Future<void> fetchRepositories(int page) async {
    _isLoading = true;
    notifyListeners();

    try {
      final repos = await _apiController.fetchRepositories(page);
      _repositories.addAll(repos);
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
