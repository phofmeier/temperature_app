import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:temperature_app/repository/socket_io_api.dart';

class TemperatureServerConnectionStatus extends Equatable {
  final TemperatureServerConnectionState state;

  final dynamic message;

  const TemperatureServerConnectionStatus(this.state, this.message);

  @override
  List<Object?> get props => [state, message];
}

enum TemperatureServerConnectionState {
  initial,
  connecting,
  connected,
  disconnecting,
  disconnected,
  error,
}

class TemperatureServerRepository {
  final _controllerConnectionStatus =
      StreamController<TemperatureServerConnectionStatus>();
  final _controllerNewTempData = StreamController();
  late final socketIoApi = SocketIOApi(
      onConnectCb: connected,
      connectingCb: connecting,
      errorCb: error,
      disconnectedCb: disconnected)
    ..addSubscription("new_temp_data", sIOnewTempData);

// Streams
  Stream<TemperatureServerConnectionStatus> get status async* {
    // await Future<void>.delayed(const Duration(seconds: 1));
    // yield TemperatureServerConnectionStatus.initial;
    yield* _controllerConnectionStatus.stream;
  }

  Stream get newTempData async* {
    // await Future<void>.delayed(const Duration(seconds: 1));
    // yield TemperatureServerConnectionStatus.initial;
    yield* _controllerNewTempData.stream;
  }

  // Public API
  void connect() {
    socketIoApi.connect();
    _controllerConnectionStatus.add(const TemperatureServerConnectionStatus(
        TemperatureServerConnectionState.connecting, ""));
  }

  void disconnect() {
    socketIoApi.disconnect();
  }

  void setUri(String uri) {
    socketIoApi.setUri(uri);
  }

  // SocketIO API

  void sIOnewTempData(data) {
    _controllerNewTempData.add(data);
  }

  void connecting(message) {
    _controllerConnectionStatus.add(TemperatureServerConnectionStatus(
        TemperatureServerConnectionState.connecting, message));
  }

  void connected() {
    _controllerConnectionStatus.add(const TemperatureServerConnectionStatus(
        TemperatureServerConnectionState.connected, ""));
  }

  void disconnected() {
    _controllerConnectionStatus.add(const TemperatureServerConnectionStatus(
        TemperatureServerConnectionState.disconnected, ""));
  }

  void error(message) {
    _controllerConnectionStatus.add(TemperatureServerConnectionStatus(
        TemperatureServerConnectionState.error, message));
  }

  void dispose() {
    _controllerConnectionStatus.close();
    _controllerNewTempData.close();
  }
}
