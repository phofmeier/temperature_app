part of 'server_connection_bloc.dart';

sealed class ServerConnectionState extends Equatable {
  const ServerConnectionState(this.temperatureServerConnectionStatus);
  final TemperatureServerConnectionStatus temperatureServerConnectionStatus;

  @override
  List<Object> get props => [temperatureServerConnectionStatus];
}

final class ServerConnectionInitial extends ServerConnectionState {
  const ServerConnectionInitial()
      : super(TemperatureServerConnectionStatus.initial);
}

final class ServerConnectionChanged extends ServerConnectionState {
  const ServerConnectionChanged(super.status);
}
