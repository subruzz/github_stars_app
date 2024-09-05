import 'package:flutter/material.dart';
import 'package:github_starts_app/view/widgets/home_screen/github_repo_card.dart';
import 'package:github_starts_app/view/widgets/home_screen/shimmer_github_repo_card.dart';
import 'package:provider/provider.dart';

import '../../../providers/repo_provider.dart';
import '../../../utils/constants/ui_constants.dart';
import '../common/messenger.dart';

class RepoListingSection extends StatelessWidget {
  const RepoListingSection({super.key, required this.scrollController});
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return Consumer<TopStarredReposProvider>(
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
            child: Text(textAlign: TextAlign.center, repoProvider.hasError!),
          );
        }
        // Show shimmer loading when fetching data
        if (repoProvider.isLoading && repoProvider.repositories.isEmpty) {
          return const ShimmerGithubRepoCard();
        }

        // Display list of repositories with a loading indicator at the end if more data is available
        return ListView.builder(
          controller: scrollController,
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
    );
  }
}
