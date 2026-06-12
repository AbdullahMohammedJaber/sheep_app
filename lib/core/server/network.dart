import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkManager {
  NetworkManager._();

  static final Connectivity _connectivity = Connectivity();

  static Future<bool> hasInternetConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    return await InternetConnectionChecker().hasConnection;
  }
}
