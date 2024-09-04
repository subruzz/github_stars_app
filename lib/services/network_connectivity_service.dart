import 'package:connectivity_plus/connectivity_plus.dart';

/// A service class for checking the network connectivity status.
///
/// This class uses the `connectivity_plus` package to determine the current network status
/// and returns whether the device is connected to the internet.
class NetworkConnectivityService {
  final Connectivity _connectivity;

  NetworkConnectivityService({required Connectivity connectivity})
      : _connectivity = connectivity;

  /// Private constructor to prevent instantiation from outside the class

  /// Checks the current network connectivity status.
  ///
  /// This method checks whether the device is connected to any network (mobile, Wi-Fi, or Ethernet).
  /// It returns `true` if a network connection is available, and `false` otherwise.
  Future<bool> checkifNetworkAvailable() async {
    final List<ConnectivityResult> connectivityResult =
        await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    // Check if the connectivity result indicates an available network connection
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet);
  }
}
