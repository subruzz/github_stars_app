import 'package:flutter/material.dart';
import 'package:github_starts_app/utils/constants/ui_constants.dart';
import 'package:github_starts_app/view/widgets/github_repo_card.dart';
import 'package:github_starts_app/view/widgets/messenger.dart';
import 'package:github_starts_app/view/widgets/shimmer_github_repo_card.dart';
import 'package:github_starts_app/view/widgets/star.dart';
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

    // Listener to load more repos on scroll end
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreRepos();
      }
    });
  }

  void _fetchRepos() {
    // Fetch initial repos when the widget is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TopStarredReposProvider>().fetchInitialRepo();
    });
  }

  void _fetchMoreRepos() {
    // Fetch more repos when the user scrolls to the bottom
    if (!context.read<TopStarredReposProvider>().isLoading &&
        context.read<TopStarredReposProvider>().hasMoreData) {
      context.read<TopStarredReposProvider>().fetchMoreOnLoad();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [Text('GitHubStarTrack'), kSizedBoxWidth15, Star()],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchRepos();
        },
        child: Consumer<TopStarredReposProvider>(
          builder: (context, repoProvider, child) {
            // Handle error state
            if (repoProvider.hasError != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Messenger.showSnackBar(
                    message: repoProvider.hasError!, color: kWarning);
              });
            }
            if (repoProvider.hasError != null &&
                !repoProvider.isLoading &&
                repoProvider.repositories.isEmpty) {
              return Center(
                child:
                    Text(textAlign: TextAlign.center, repoProvider.hasError!),
              );
            }
            // Show shimmer loading when fetching data
            if (repoProvider.isLoading && repoProvider.repositories.isEmpty) {
              return const ShimmerGithubRepoCard();
            }

            // Display list of repositories with a loading indicator at the end if more data is available
            return ListView.builder(
              controller: _scrollController,
              itemCount: repoProvider.repositories.length +
                  (repoProvider.hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == repoProvider.repositories.length) {
                  // Loading indicator at the bottom when fetching more data
                  return const Center(child: CircularProgressIndicator());
                }

                final repo = repoProvider.repositories[index];
                return GithubRepoCard(repo: repo);
              },
            );
          },
        ),
      ),
    );
  }
}
