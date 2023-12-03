import 'dart:async';

import 'package:temperature_app/repository/socket_io_api.dart';

enum TemperatureServerConnectionStatus {
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
    _controllerConnectionStatus
        .add(TemperatureServerConnectionStatus.connecting);
  }

  void disconnect() {
    socketIoApi.disconnect();
  }

  // SocketIO API

  void sIOnewTempData(data) {
    _controllerNewTempData.add(data);
  }

  void connecting() {
    _controllerConnectionStatus
        .add(TemperatureServerConnectionStatus.connecting);
  }

  void connected() {
    _controllerConnectionStatus
        .add(TemperatureServerConnectionStatus.connected);
  }

  void disconnected() {
    _controllerConnectionStatus
        .add(TemperatureServerConnectionStatus.disconnected);
  }

  void error() {
    _controllerConnectionStatus.add(TemperatureServerConnectionStatus.error);
  }

  void dispose() {
    _controllerConnectionStatus.close();
    _controllerNewTempData.close();
  }
}
