import 'package:flutter/material.dart';
import 'package:github_starts_app/providers/repo_provider.dart';
import 'package:github_starts_app/view/screens/repo_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TopStarredReposProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GitHub Repos',
        home: RepoListScreen(),
      ),
    );
  }
}
