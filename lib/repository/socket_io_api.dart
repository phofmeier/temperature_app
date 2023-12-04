import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class SocketIOApi {
  late final socket_io.Socket _socket;

  void Function()? onConnectCb;
  void Function(dynamic)? connectingCb;
  void Function(dynamic)? errorCb;
  void Function()? disconnectedCb;

  SocketIOApi(
      {this.onConnectCb,
      this.connectingCb,
      this.errorCb,
      this.disconnectedCb}) {
    _socket = socket_io.io(
      'http://localhost:5000/js',
      socket_io.OptionBuilder()
          .setTimeout(3000)
          .setReconnectionDelay(5000)
          .disableAutoConnect()
          // .disableReconnection()
          .setTransports(['websocket']).build(),
    );
    _socket.onConnect((_) => onConnectCb!());
    _socket.onConnecting((data) => connectingCb!(data));
    _socket.onConnectError((data) => errorCb!(data));
    _socket.onConnectTimeout((data) => errorCb!(data));
    _socket.onDisconnect((_) => disconnectedCb!());
    _socket.onError((data) => errorCb!(data));
  }

  void addSubscription(String channel, dynamic Function(dynamic) callback) {
    _socket.on(channel, callback);
  }

  void disconnect() {
    _socket.disconnect();
  }

  void connect() {
    _socket.connect();
  }
}
