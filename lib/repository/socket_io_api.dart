import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:temperature_app/gen/submodule/temperature_proto/proto/settings.pb.dart';

class SocketIOApi {
  late socket_io.Socket _socket;
  String uri = 'http://localhost:5000/pb';

  void Function()? onConnectCb;
  void Function(dynamic)? connectingCb;
  void Function(dynamic)? errorCb;
  void Function()? disconnectedCb;

  SocketIOApi(
      {this.onConnectCb,
      this.connectingCb,
      this.errorCb,
      this.disconnectedCb}) {
    _initialize();
  }

  void _initialize() {
    _socket = socket_io.io(
      uri,
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

  void setUri(String uri) {
    this.uri = uri;
    disconnect();
    _socket.dispose();
    _initialize();
  }

  void getSettings() {
    _socket.emitWithAck("getSettings", "", ack: (data) {
      print(data);
      Settings settingMsg = Settings.fromBuffer(data);
      print(settingMsg);
    });
  }
}
