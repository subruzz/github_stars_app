import 'package:flutter/material.dart';
import 'package:github_starts_app/view/widgets/home_screen/home_app_bar.dart';
import 'package:github_starts_app/view/widgets/home_screen/repo_listing_section.dart';
import 'package:provider/provider.dart';
import '../../providers/repo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
          onRefresh: () async {
            _fetchRepos();
          },
          child: RepoListingSection(scrollController: _scrollController)),
    );
  }
}
