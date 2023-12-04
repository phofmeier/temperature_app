import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/repository/temperature_server_repository.dart';

part 'server_connection_event.dart';
part 'server_connection_state.dart';

class ServerConnectionBloc
    extends Bloc<ServerConnectionEvent, ServerConnectionState> {
  TemperatureServerRepository temperatureServerRepository;

  ServerConnectionBloc({required this.temperatureServerRepository})
      : super(const ServerConnectionInitial()) {
    temperatureServerRepository.status.listen(
        (event) => add(TemperatureServerConnectionStatusChangedEvent(event)));
    on<TemperatureServerConnectionStatusChangedEvent>((event, emit) {
      emit(ServerConnectionChanged(event.temperatureServerConnectionStatus));
    });
  }
}
