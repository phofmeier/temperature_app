import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:temperature_app/blocs/app_settings/app_settings_bloc.dart';
import 'package:temperature_app/gen/submodule/temperature_proto/proto/settings.pb.dart';
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
      StreamController<TemperatureServerConnectionStatus>.broadcast();
  final _controllerNewTempData = StreamController();
  final _settingsMessageStream = StreamController<Settings>();
  final _settingsEventStream =
      StreamController<AppSettingsServerSettingChanged>();
  late final socketIoApi = SocketIOApi(
      onConnectCb: connected,
      connectingCb: connecting,
      errorCb: error,
      disconnectedCb: disconnected)
    ..addSubscription("new_temp_data", sIOnewTempData);
  TemperatureServerConnectionState currentState =
      TemperatureServerConnectionState.initial;
  TemperatureServerRepository() {
    _controllerConnectionStatus.add(const TemperatureServerConnectionStatus(
        TemperatureServerConnectionState.initial, ""));
    _settingsMessageStream.stream.listen((event) {
      _settingsEventStream.add(AppSettingsServerSettingChanged(
          ovenTargetTemperature: event.ovenTargetTemperature,
          coreTargetTemperature: event.coreTargetTemperature));
    });
  }

// Streams
  Stream<TemperatureServerConnectionStatus> get status async* {
    // await Future<void>.delayed(const Duration(seconds: 1));
    // yield TemperatureServerConnectionStatus.initial;
    yield* _controllerConnectionStatus.stream;
  }

  Stream<AppSettingsServerSettingChanged> get appSettingsServerSetting async* {
    // await Future<void>.delayed(const Duration(seconds: 1));
    // yield TemperatureServerConnectionStatus.initial;
    yield* _settingsEventStream.stream;
  }

  Stream get newTempData async* {
    // await Future<void>.delayed(const Duration(seconds: 1));
    // yield TemperatureServerConnectionStatus.initial;
    yield* _controllerNewTempData.stream;
  }

  // Public API
  void connect() {
    socketIoApi.connect();
    currentState = TemperatureServerConnectionState.connecting;
    _controllerConnectionStatus
        .add(TemperatureServerConnectionStatus(currentState, ""));
  }

  void disconnect() {
    socketIoApi.disconnect();
  }

  void setUri(String uri) {
    socketIoApi.setUri(uri);
  }

  void triggerGetSettings() {
    socketIoApi.getSettings(_settingsMessageStream);
  }

  bool isConnected() {
    return currentState == TemperatureServerConnectionState.connected;
  }

  // SocketIO API

  void sIOnewTempData(data) {
    _controllerNewTempData.add(data);
  }

  void connecting(message) {
    currentState = TemperatureServerConnectionState.connecting;
    _controllerConnectionStatus
        .add(TemperatureServerConnectionStatus(currentState, message));
  }

  void connected() {
    currentState = TemperatureServerConnectionState.connected;
    _controllerConnectionStatus
        .add(TemperatureServerConnectionStatus(currentState, ""));
  }

  void disconnected() {
    currentState = TemperatureServerConnectionState.disconnected;
    _controllerConnectionStatus
        .add(TemperatureServerConnectionStatus(currentState, ""));
  }

  void error(message) {
    currentState = TemperatureServerConnectionState.error;
    _controllerConnectionStatus
        .add(TemperatureServerConnectionStatus(currentState, message));
  }

  void dispose() {
    _controllerConnectionStatus.close();
    _controllerNewTempData.close();
  }
}
