import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:temperature_app/repository/temperature_server_repository.dart';

class SocketIOApi {
  final TemperatureServerRepository repository;
  late final socket_io.Socket _socket;
  SocketIOApi(this.repository) {
    _socket = socket_io.io(
      'http://localhost:5000/js',
      socket_io.OptionBuilder()
          .setTimeout(3000)
          .setReconnectionDelay(5000)
          .disableAutoConnect()
          .disableReconnection()
          .setTransports(['websocket']).build(),
    );
    _socket.onConnect((_) => repository.connected());
    _socket.onConnecting((data) => repository.connecting());
    _socket.onConnectError((data) => repository.error());
    _socket.onConnectTimeout((data) => repository.error());
    _socket.onDisconnect((_) => repository.disconnected());
    _socket.onError((data) => repository.error());
    _socket.on("new_temp_data", (data) => repository.sIOnewTempData(data));
  }

  void disconnect() {
    _socket.disconnect();
  }

  void connect() {
    _socket.connect();
  }
}
