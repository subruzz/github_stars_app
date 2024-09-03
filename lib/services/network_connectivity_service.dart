import 'package:connectivity_plus/connectivity_plus.dart';

/// A service class for checking the network connectivity status.
///
/// This class uses the `connectivity_plus` package to determine the current network status
/// and returns whether the device is connected to the internet.
class NetworkConnectivityService {
  // Private constructor to prevent instantiation from outside the class
  NetworkConnectivityService._internal();

  // Singleton instance
  static final NetworkConnectivityService _instance =
      NetworkConnectivityService._internal();

  /// Factory constructor to provide the singleton instance
  factory NetworkConnectivityService() => _instance;

  /// Checks the current network connectivity status.
  ///
  /// This method checks whether the device is connected to any network (mobile, Wi-Fi, or Ethernet).
  /// It returns `true` if a network connection is available, and `false` otherwise.
  Future<bool> checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    // Check if the connectivity result indicates an available network connection
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true; // Network connection is available.
    } else {
      return false; // No network connection is available.
    }
  }
}
