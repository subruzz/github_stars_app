import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/repo_provider.dart';

class RepoListScreen extends StatefulWidget {
  const RepoListScreen({super.key});

  @override
  State<RepoListScreen> createState() => _RepoListScreenState();
}

class _RepoListScreenState extends State<RepoListScreen> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchRepos();
  }

  void _fetchRepos() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TopStarredReposProvider>(context, listen: false)
          .fetchRepositories(_currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final repoProvider = Provider.of<TopStarredReposProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Most Starred Repos'),
      ),
      body: repoProvider.isLoading && repoProvider.repositories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: repoProvider.repositories.length,
              itemBuilder: (context, index) {
                final repo = repoProvider.repositories[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(repo.ownerAvatarUrl),
                  ),
                  title: Text(repo.name),
                  subtitle: Text(repo.description),
                  trailing: Text('${repo.stars} ⭐'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentPage++;
            _fetchRepos();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
