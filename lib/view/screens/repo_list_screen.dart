import 'package:flutter/material.dart';
import 'package:github_starts_app/utils/constants/ui_constants.dart';
import 'package:github_starts_app/view/widgets/github_repo_card.dart';
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

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreRepos();
      }
    });
  }

  void _fetchRepos() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TopStarredReposProvider>().fetchInitialRepo();
    });
  }

  void _fetchMoreRepos() {
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
    final repoProvider = context.read<TopStarredReposProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [Text('GitHubStarTrack'), kSizedBoxWidth15, Star()],
        ),
      ),
      body: RefreshIndicator(onRefresh: () async {
        _fetchRepos();
      }, child: Consumer<TopStarredReposProvider>(
        builder: (context, value, child) {
          return repoProvider.hasError
              ? const Center(
                  child: Text('Something went wrong,please try again!'),
                )
              : repoProvider.isLoading
                  ? const ShimmerGithubRepoCard()
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: repoProvider.repositories.length +
                          (repoProvider.hasMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == repoProvider.repositories.length) {
                          // Display loading indicator at the end of the list
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final repo = repoProvider.repositories[index];
                        return GithubRepoCard(repo: repo);
                      },
                    );
        },
      )),
    );
  }
}
