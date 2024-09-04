import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:github_starts_app/services/network_connectivity_service.dart';
import 'package:mocktail/mocktail.dart';
import '../test_utils/classes/mock_classes.dart';

void main() {
  // Ensures the test environment is initialized before running tests.
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockConnectivity mockConnectivity;
  late NetworkConnectivityService networkConnectivityService;

  setUp(() { 
    // Initializes mock objects and the NetworkConnectivityService instance
    // with the mocked connectivity service.
    mockConnectivity = MockConnectivity();
    networkConnectivityService =
        NetworkConnectivityService(connectivity: mockConnectivity);
  });

  group('Network Connectivity Check', () {
    test('checkConnectivity returns true when connected to mobile network',
        () async {
      // Arrange: Configure the mock to return a mobile network connection.
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.mobile],
      );

      // Act: Call the method to check network availability.
      final result = await networkConnectivityService.checkifNetworkAvailable();

      // Assert: Verify that the result indicates a network is available.
      expect(result, isTrue);
    });

    test('checkConnectivity returns true when connected to Wi-Fi', () async {
      // Arrange: Configure the mock to return a Wi-Fi connection.
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi],
      );

      // Act: Call the method to check network availability.
      final result = await networkConnectivityService.checkifNetworkAvailable();

      // Assert: Verify that the result indicates a network is available.
      expect(result, isTrue);
    });

    test('checkConnectivity returns true when connected to Ethernet', () async {
      // Arrange: Configure the mock to return an Ethernet connection.
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.ethernet],
      );

      // Act: Call the method to check network availability.
      final result = await networkConnectivityService.checkifNetworkAvailable();

      // Assert: Verify that the result indicates a network is available.
      expect(result, isTrue);
    });

    test('checkConnectivity returns false when not connected to any network',
        () async {
      // Arrange: Configure the mock to return no network connection.
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.none],
      );

      // Act: Call the method to check network availability.
      final result = await networkConnectivityService.checkifNetworkAvailable();

      // Assert: Verify that the result indicates no network is available.
      expect(result, isFalse);
    });
  });
}
