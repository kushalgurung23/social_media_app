import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:spa_app/data/enum/network_status_enum.dart';

class NetworkService {
  StreamController<NetworkStatus> networkServiceController = StreamController();

  NetworkService() {
    Connectivity().onConnectivityChanged.listen((event) {
      networkServiceController.add(_networkStatus(event));
    });
  }

  NetworkStatus _networkStatus(ConnectivityResult connectivityResult) {
    return connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi
        ? NetworkStatus.online
        : NetworkStatus.offline;
  }
}
