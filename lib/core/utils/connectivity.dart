import 'dart:async';
import 'dart:io';

enum ConnectivityStatus { online, offline }

class ConnectivityObserver {
  Function offlineAction;
  Function onlineAction;
  Duration interval;
  Timer timerHandler;
  ConnectivityStatus previousResult;
  NetworkHandler networkHandler;

  ConnectivityObserver({
    ip = '8.8.8.8',
    port = 53,
    socketTimeout = const Duration(milliseconds: 3000),
    this.offlineAction,
    this.onlineAction,
    this.interval = const Duration(milliseconds: 1000),
  }) {
    this.networkHandler = NetworkHandler(ip, port, socketTimeout);
  }

  void connectionTest() {
    const ConnectivityStatus offline = ConnectivityStatus.offline;
    const ConnectivityStatus online = ConnectivityStatus.online;
    this.timerHandler = Timer.periodic(
      this.interval,
      (timer) async {
        ConnectivityStatus pingResult = await this.networkHandler.pingIP();
        if (pingResult == online && this.previousResult != online) {
          if (this.onlineAction != null) this.onlineAction.call();
          this.previousResult = ConnectivityStatus.online;
        } else if (pingResult == offline && this.previousResult != offline) {
          if (this.offlineAction != null) this.offlineAction.call();
          this.previousResult = ConnectivityStatus.offline;
        }
      },
    );
  }
}

/// Cusotm network handler class. to detect/handle connectivity of network.
class NetworkHandler {
  Duration socketTimeout;

  String ip;

  int port;

  InternetAddress get pinagableIP =>
      InternetAddress(this.ip, type: InternetAddressType.IPv4);

  NetworkHandler(this.ip, this.port, this.socketTimeout);

  Future<ConnectivityStatus> pingIP() async {
    try {
      final Socket connect = await Socket.connect(
        this.pinagableIP,
        this.port,
        timeout: this.socketTimeout,
      );
      connect.destroy();
      connect.close();
      return ConnectivityStatus.online;
    } on SocketException {
      return ConnectivityStatus.offline;
    }
  }
}
