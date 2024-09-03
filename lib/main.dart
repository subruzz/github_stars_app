import 'package:flutter/material.dart';
import 'package:github_starts_app/providers/repo_provider.dart';
import 'package:github_starts_app/view/screens/repo_list_screen.dart';
import 'package:github_starts_app/view/widgets/messenger.dart';
import 'package:provider/provider.dart';
import 'utils/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      child: MaterialApp(
        scaffoldMessengerKey: Messenger.scaffoldKey,
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        title: 'GitHub Repos',
        home: const RepoListScreen(),
      ),
    );
  }
}
