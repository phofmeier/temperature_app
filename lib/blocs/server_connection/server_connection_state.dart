part of 'server_connection_bloc.dart';

sealed class ServerConnectionState extends Equatable {
  final TemperatureServerConnectionStatus temperatureServerConnectionStatus;

  const ServerConnectionState(this.temperatureServerConnectionStatus);

  @override
  List<Object> get props => [temperatureServerConnectionStatus];
}

final class ServerConnectionInitial extends ServerConnectionState {
  const ServerConnectionInitial()
      : super(const TemperatureServerConnectionStatus(
            TemperatureServerConnectionState.initial, ""));
}

final class ServerConnectionChanged extends ServerConnectionState {
  const ServerConnectionChanged(super.status);
}
