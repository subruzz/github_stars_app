import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:github_starts_app/services/network_connectivity_service.dart';
import 'package:github_starts_app/services/sqflite_services.dart';
import 'package:github_starts_app/view/widgets/messenger.dart';
import 'package:dio/dio.dart';
import 'package:github_starts_app/services/top_starred_repository_api_service.dart';
import 'package:mocktail/mocktail.dart';


class MockTopStarredRepositoryApiService extends Mock
    implements TopStarredRepositoryApiService {}

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

class MockDio extends Mock implements Dio {}

class MockConnectivity extends Mock implements Connectivity {}

class MockMessenger extends Mock implements Messenger {}

class MockNetworkConnectivityService extends Mock
    implements NetworkConnectivityService {}

void main() {}
