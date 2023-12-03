part of 'server_connection_bloc.dart';

sealed class ServerConnectionEvent extends Equatable {}

class TemperatureServerConnectionStatusChangedEvent
    extends ServerConnectionEvent {
  final TemperatureServerConnectionStatus temperatureServerConnectionStatus;

  TemperatureServerConnectionStatusChangedEvent(
      this.temperatureServerConnectionStatus);

  @override
  List<Object> get props => [temperatureServerConnectionStatus];
}
