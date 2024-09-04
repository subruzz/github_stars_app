import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:github_starts_app/services/network_connectivity_service.dart';
import 'package:github_starts_app/services/sqflite_services.dart';
import 'package:github_starts_app/view/widgets/messenger.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:github_starts_app/services/top_starred_repository_api_service.dart';

@GenerateMocks([
  TopStarredRepositoryApiService,
  DatabaseHelper,
  Dio,
  Connectivity,
  Messenger,
  NetworkConnectivityService
])
void main() {}
