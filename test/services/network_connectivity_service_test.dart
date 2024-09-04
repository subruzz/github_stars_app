import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:github_starts_app/services/network_connectivity_service.dart';
import '../test_utils/classes/mock_classes.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockConnectivity mockConnectivity;
  late NetworkConnectivityService networkConnectivityService;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkConnectivityService =
        NetworkConnectivityService(connectivity: mockConnectivity);
  });

  group('connectiviy check', () {
    test('checkConnectivity returns true when connected to mobile network',
        () async {
      // Arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.mobile],
      );

      // Act
      final result = await networkConnectivityService.checkifNetworkAvailable();

      // Assert
      expect(result, isTrue);
    });

    test('checkConnectivity returns true when connected to Wi-Fi', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi],
      );

      // Act
      final result = await networkConnectivityService.checkifNetworkAvailable();

      // Assert
      expect(result, isTrue);
    });

    test('checkConnectivity returns true when connected to Ethernet', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.ethernet],
      );

      // Act
      final result = await networkConnectivityService.checkifNetworkAvailable();

      // Assert
      expect(result, isTrue);
    });

    test('checkConnectivity returns false when not connected to any network',
        () async {
      // Arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.none],
      );

      // Act
      final result = await networkConnectivityService.checkifNetworkAvailable();
      print('Connectivity result: $result'); // Debug print

      // Assert
      expect(result, false); // Correct expectation
    });
  });
}
