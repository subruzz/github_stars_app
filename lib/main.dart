import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github_starts_app/providers/repo_provider.dart';
import 'package:github_starts_app/services/network_connectivity_service.dart';
import 'package:github_starts_app/services/sqflite_services.dart';
import 'package:github_starts_app/services/top_starred_repository_api_service.dart';
import 'package:github_starts_app/view/screens/splash_screen.dart';
import 'package:github_starts_app/view/widgets/common/messenger.dart';
import 'package:provider/provider.dart';
import 'utils/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

final TopStarredRepositoryApiService apiService =
    TopStarredRepositoryApiService(dio: Dio());
final DatabaseHelper databaseHelper = DatabaseHelper();
final NetworkConnectivityService networkConnectivityService =
    NetworkConnectivityService(connectivity: Connectivity());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TopStarredReposProvider(
            networkConnectivityService: networkConnectivityService,
            apiController: apiService,
            databaseHelper: databaseHelper,
          ),
        )
      ],
      child: MaterialApp(
        scaffoldMessengerKey: Messenger.scaffoldKey,
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        title: 'GitHub Star Track',
        home: const SplashScreen(),
      ),
    );
  }
}
