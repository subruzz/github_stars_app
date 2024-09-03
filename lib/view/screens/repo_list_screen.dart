import 'package:flutter/material.dart';
import 'package:github_starts_app/view/widgets/github_repo_card.dart';
import 'package:provider/provider.dart';
import '../../providers/repo_provider.dart';

class RepoListScreen extends StatefulWidget {
  const RepoListScreen({super.key});

  @override
  State<RepoListScreen> createState() => _RepoListScreenState();
}

class _RepoListScreenState extends State<RepoListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fetchRepos();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreRepos();
      }
    });
  }

  void _fetchRepos() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TopStarredReposProvider>(context, listen: false)
          .fetchRepositories();
    });
  }

  void _fetchMoreRepos() {
    if (!Provider.of<TopStarredReposProvider>(context, listen: false)
            .isLoading &&
        Provider.of<TopStarredReposProvider>(context, listen: false)
            .hasMoreData) {
      Provider.of<TopStarredReposProvider>(context, listen: false)
          .fetchRepositories();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repoProvider = Provider.of<TopStarredReposProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Most Starred Repos'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: repoProvider.repositories.length +
            1, // Add one more for the loading indicator
        itemBuilder: (context, index) {
          if (index == repoProvider.repositories.length) {
            // Display loading indicator at the end of the list
            return repoProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink(); // Empty container if not loading
          }

          final repo = repoProvider.repositories[index];
          return GithubRepoCard(repo: repo);
        },
      ),
    );
  }
}
